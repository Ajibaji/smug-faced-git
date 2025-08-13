#!/usr/bin/env bash

# post-install configuration scripts go here

printf "\n\nAllowing docker to be used by non-root...\n"
sudo groupadd -f docker
sudo usermod -aG docker $(whoami)
rm -rf ~/.docker
newgrp docker
