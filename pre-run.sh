#!/usr/bin/env bash

# install dotbot dependencies and add required apt repositories

sudo apt update

sudo apt install wget zip unzip apt-transport-https ca-certificates curl gnupg software-properties-common fontconfig -y

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
  curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
  sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg
  echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
  sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list
fi

if ! command -v dotnet; then
  printf "\n\ninstalling dotnet...\n"
  wget https://dot.net/v1/dotnet-install.sh -o dotnet-install.sh
  chmod +x ./dotnet-install.sh 
  ./dotnet-install.sh --channel 8.0
  ./dotnet-install.sh --channel 7.0
  ./dotnet-install.sh --channel 6.0
  ./dotnet-install.sh --channel 3.1
  rm dotnet-install.sh

  export DOTNET_ROOT=$HOME/.dotnet
  export PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools
  dotnet tool install --global csharp-ls
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

printf "\n\nAdding mesa apt repo...\n"
sudo add-apt-repository ppa:kisak/kisak-mesa

if ! command -v hx; then
  printf "\n\nAdding helix apt repo...\n"
  sudo add-apt-repository ppa:maveonair/helix-editor
fi

if ! command -v R; then
  printf "\n\nAdding CRAN (R lang) apt repo...\n"
  sudo apt install --no-install-recommends software-properties-common dirmngr
  wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
  sudo add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"
fi

sudo apt update
sudo apt upgrade -y
