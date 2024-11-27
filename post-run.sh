#!/usr/bin/env bash

# post-install configuration scripts go here

printf "\n\nallowing docker to be used by non-root...\n"
sudo groupadd docker
sudo usermod -ag docker $user
rm -rf ~/.docker
