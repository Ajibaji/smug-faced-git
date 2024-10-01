# install dotbot requirements and add required apt repositories

sudo apt update

sudo apt install wget zip unzip apt-transport-https ca-certificates curl gnupg software-properties-common -y

if ! command -v fnm; then
  curl -fssl https://fnm.vercel.app/install | bash
  FNM_PATH="/home/ammar/.local/share/fnm"
  export PATH="$FNM_PATH:$PATH"
  eval "`fnm env`"
  fnm install v20
  fnm install v18
  fnm install v16
  fnm default v20
fi

if ! command -v cargo; then
  printf "\n\ninstalling cargo-binstall...\n"
  curl https://sh.rustup.rs -ssf | sh -s -- -y
  curl -l --proto '=https' --tlsv1.2 -ssf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash
  export PATH="${HOME}/.cargo/bin:${PATH}"
  cargo binstall -y cargo-update
  cargo install-update -a
fi

if ! command -v docker; then
  printf "\n\nadding docker apt repo...\n"
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fssl https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
fi

if ! command -v kubectl; then
  printf "\n\nadding kubernetes apt repo...\n"
  curl -fssl https://pkgs.k8s.io/core:/stable:/v1.31/deb/release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
  sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg
  echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
  sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list
fi

if ! command -v az; then
  printf "\n\nadding azure-cli apt repo...\n"
  curl -sls https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/keyrings/microsoft.gpg > /dev/null
  sudo chmod go+r /etc/apt/keyrings/microsoft.gpg

  az_dist=$(lsb_release -cs)

  echo "types: deb
uris: https://packages.microsoft.com/repos/azure-cli
suites: ${az_dist}
components: main
architectures: $(dpkg --print-architecture)
signed-by: /etc/apt/keyrings/microsoft.gpg" | sudo tee /etc/apt/sources.list.d/azure-cli.sources
fi

if ! command -v terraform; then
  printf "\n\nadding hashicorp apt repo...\n"
  wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
fi

if ! command -v nvim; then
  printf "\n\nAdding neovim apt repo...\n"
  sudo add-apt-repository ppa:neovim-ppa/unstable -y
fi

sudo apt update
