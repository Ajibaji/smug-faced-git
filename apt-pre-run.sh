# this script should contain only the commands to add sources to the apt repository list
# there is a `sudo apt update` at the end so don't add it


echo "adding docker apt repo..."
if ! command -v docker; then
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fssl https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc

  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$version_codename") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
fi

echo "adding kubernetes apt repo..."
if ! command -v kubectl; then
  curl -fssl https://pkgs.k8s.io/core:/stable:/v1.31/deb/release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
  sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg

  echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
  sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list
fi

echo "adding azure-cli apt repo..."
if ! command -v az; then
  curl -sls https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/keyrings/microsoft.gpg > /dev/null
  sudo chmod go+r /etc/apt/keyrings/microsoft.gpg

  az_dist=$(lsb_release -cs)

  echo "types: deb
  uris: https://packages.microsoft.com/repos/azure-cli/
  suites: ${az_dist}
  components: main
  architectures: $(dpkg --print-architecture)
  signed-by: /etc/apt/keyrings/microsoft.gpg" | sudo tee /etc/apt/sources.list.d/azure-cli.sources
fi

echo "adding hashicorp apt repo..."
if ! command -v terraform; then
  wget -o- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
fi

echo "Adding neovim apt repo..."
sudo add-apt-repository ppa:neovim-ppa/unstable -y

sudo apt update
