// Command az is a single-file launcher for a frozen Azure CLI.
//
// The whole PyInstaller onedir tree is embedded as one solid LZMA stream. On
// first run it is unpacked into a versioned cache directory; every later run
// just execs the already-unpacked az.exe, so there is no per-invocation
// extraction cost (which is the thing that makes PyInstaller --onefile
// unpleasant for an interactive CLI).
//
// Build is pure Go with CGO disabled, so the result is a static PE with no
// runtime dependencies.
package main

import (
	"archive/tar"
	"bytes"
	_ "embed"
	"errors"
	"fmt"
	"io"
	"os"
	"os/exec"
	"os/signal"
	"path/filepath"
	"strings"

	"github.com/ulikunitz/xz"
)

//go:embed payload.tar.xz
var payload []byte

//go:embed payload.id
var payloadID string

const appName = "az-static"

// cacheRoot is %LOCALAPPDATA%\az-static on Windows, overridable for portable
// / locked-down environments.
func cacheRoot() (string, error) {
	if v := strings.TrimSpace(os.Getenv("AZ_STATIC_HOME")); v != "" {
		return v, nil
	}
	base, err := os.UserCacheDir()
	if err != nil {
		return "", fmt.Errorf("locating cache dir: %w", err)
	}
	return filepath.Join(base, appName), nil
}

// unpack writes the embedded archive into dst, rejecting any entry that would
// escape it.
func unpack(dst string) error {
	xr, err := xz.NewReader(bytes.NewReader(payload))
	if err != nil {
		return fmt.Errorf("opening payload: %w", err)
	}
	tr := tar.NewReader(xr)

	for {
		hdr, err := tr.Next()
		if errors.Is(err, io.EOF) {
			return nil
		}
		if err != nil {
			return fmt.Errorf("reading payload: %w", err)
		}

		target, err := safeJoin(dst, hdr.Name)
		if err != nil {
			return err
		}

		switch hdr.Typeflag {
		case tar.TypeDir:
			if err := os.MkdirAll(target, 0o755); err != nil {
				return err
			}
		case tar.TypeReg:
			if err := os.MkdirAll(filepath.Dir(target), 0o755); err != nil {
				return err
			}
			f, err := os.OpenFile(target, os.O_CREATE|os.O_WRONLY|os.O_TRUNC, os.FileMode(hdr.Mode)|0o200)
			if err != nil {
				return err
			}
			if _, err := io.Copy(f, tr); err != nil {
				f.Close()
				return err
			}
			if err := f.Close(); err != nil {
				return err
			}
		default:
			// Symlinks etc. do not occur in a Windows PyInstaller bundle.
			continue
		}
	}
}

func safeJoin(root, name string) (string, error) {
	clean := filepath.Clean(filepath.FromSlash(name))
	if filepath.IsAbs(clean) || strings.HasPrefix(clean, "..") {
		return "", fmt.Errorf("refusing unsafe path in payload: %q", name)
	}
	target := filepath.Join(root, clean)
	if !strings.HasPrefix(target, filepath.Clean(root)+string(os.PathSeparator)) {
		return "", fmt.Errorf("refusing unsafe path in payload: %q", name)
	}
	return target, nil
}

// ensure returns the directory holding the unpacked CLI, extracting it if this
// is the first run for this payload id.
func ensure() (string, error) {
	root, err := cacheRoot()
	if err != nil {
		return "", err
	}
	id := strings.TrimSpace(payloadID)
	if id == "" {
		return "", errors.New("empty payload id")
	}

	dir := filepath.Join(root, id)
	stamp := filepath.Join(dir, ".complete")
	if _, err := os.Stat(stamp); err == nil {
		return dir, nil
	}

	if err := os.MkdirAll(root, 0o755); err != nil {
		return "", err
	}

	// Unpack to a scratch dir, then rename into place. Concurrent launches
	// either win the rename or find the finished tree already there.
	tmp, err := os.MkdirTemp(root, ".unpack-")
	if err != nil {
		return "", err
	}
	defer os.RemoveAll(tmp)

	fmt.Fprintf(os.Stderr, "az: first run, unpacking runtime to %s ...\n", dir)
	if err := unpack(tmp); err != nil {
		return "", err
	}
	if err := os.WriteFile(filepath.Join(tmp, ".complete"), []byte(id), 0o644); err != nil {
		return "", err
	}

	if err := os.Rename(tmp, dir); err != nil {
		if _, statErr := os.Stat(stamp); statErr == nil {
			return dir, nil // lost the race, which is fine
		}
		return "", fmt.Errorf("installing runtime: %w", err)
	}
	return dir, nil
}

func run(dir string) int {
	exe := filepath.Join(dir, "az.exe")
	if _, err := os.Stat(exe); err != nil {
		exe = filepath.Join(dir, "az")
	}

	cmd := exec.Command(exe, os.Args[1:]...)
	cmd.Stdin, cmd.Stdout, cmd.Stderr = os.Stdin, os.Stdout, os.Stderr

	// The child is a console app in the same process group; let it handle
	// Ctrl+C so azure-cli's own KeyboardInterrupt path runs.
	signal.Ignore(os.Interrupt)

	if err := cmd.Run(); err != nil {
		var ee *exec.ExitError
		if errors.As(err, &ee) {
			return ee.ExitCode()
		}
		fmt.Fprintln(os.Stderr, "az: failed to launch:", err)
		return 1
	}
	return 0
}

func main() {
	dir, err := ensure()
	if err != nil {
		fmt.Fprintln(os.Stderr, "az:", err)
		os.Exit(1)
	}
	os.Exit(run(dir))
}
