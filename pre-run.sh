#!/usr/bin/env bash

# install dotbot dependencies and add required apt repositories

function printHeading() {
  printf "%119s\n" ${@}— | sed -e 's/ /—/g';
}

printHeading 'APT-INSTALL-BASE-DEPS'
sudo apt update
sudo apt install wget zip unzip apt-transport-https ca-certificates curl gnupg software-properties-common fontconfig -y

if ! command -v fnm; then
  printHeading 'FNM/NODEJS'
  curl -fssl https://fnm.vercel.app/install | bash -s -- --skip-shell
  FNM_PATH="/home/ammar/.local/share/fnm"
  export PATH="$FNM_PATH:$PATH"
  eval "`fnm env`"
  fnm install v22
  fnm install v20
  fnm install v18
  fnm default v22
  git checkout -- .
fi

if ! command -v cargo; then
  printHeading 'INSTALLING-CARGO'
  printf "\n\ninstalling cargo-binstall...\n"
  curl https://sh.rustup.rs -ssf | sh -s -- -y
  curl -l --proto '=https' --tlsv1.2 -ssf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash
  export PATH="${HOME}/.cargo/bin:${PATH}"
  cargo binstall -y cargo-update
  cargo install-update -a
  git checkout -- .
fi

if ! command -v docker; then
  printHeading 'DOCKER-APT-REPO'
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
  printHeading 'K8S-APT-REPO'
  printf "\n\nadding kubernetes apt repo...\n"
  curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.33/deb/Release.key | sudo gpg --dearmor --yes -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
  sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg
  echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.33/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
  sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list
fi

if ! command -v dotnet; then
  printHeading 'INSTALLING-DOTNET'
  printf "\n\ninstalling dotnet...\n"
  curl -fsSLO https://dot.net/v1/dotnet-install.sh
  chmod +x ./dotnet-install.sh 
  ./dotnet-install.sh --channel 9.0
  ./dotnet-install.sh --channel 8.0
  ./dotnet-install.sh --channel 3.1
  rm dotnet-install.sh
  export DOTNET_ROOT=$HOME/.dotnet
  export PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools
  dotnet tool install --global csharp-ls
  dotnet tool install --global csharpier
fi

if ! command -v az; then
  printHeading 'AZURE-CLI-APT-REPO'
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
  printHeading 'HASHICORP-APT-REPO'
  printf "\n\nadding hashicorp apt repo...\n"
  wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
fi

if ! command -v nvim; then
  printHeading 'NEOVIM-APT-REPO'
  printf "\n\nAdding neovim apt repo...\n"
  sudo add-apt-repository ppa:neovim-ppa/unstable -y
fi

printHeading 'MESA-APT-REPO'
printf "\n\nAdding mesa apt repo...\n"
sudo add-apt-repository ppa:kisak/kisak-mesa -y

if ! command -v R; then
  printHeading 'CRAN-APT-REPO'
  printf "\n\nAdding CRAN (R lang) apt repo...\n"
  sudo apt install --no-install-recommends software-properties-common dirmngr
  wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
  sudo add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/" -y
fi

printHeading 'APT-UPGRADE'
sudo apt update
sudo apt upgrade -y
