#!/bin/bash

# this runs as part of pre-build

echo "on-create start"
echo "$(date +'%Y-%m-%d %H:%M:%S')    on-create start" >> "$HOME/status"


# create local registry
docker network create k3d
k3d registry create registry.localhost --port 5500
docker network connect k3d k3d-registry.localhost

# update the base docker images
# docker pull mcr.microsoft.com/dotnet/aspnet:6.0-alpine
# docker pull mcr.microsoft.com/dotnet/sdk:6.0
# docker pull ghcr.io/cse-labs/webv-red:latest

# echo "dowloading kic CLI"
# cd cli || exit
# tag="0.4.3"
# wget -O kic.tar.gz "https://github.com/retaildevcrews/akdc/releases/download/$tag/kic-$tag-linux-amd64.tar.gz"
# tar -xvzf kic.tar.gz
# rm kic.tar.gz
# cd "$OLDPWD" || exit

echo "generating completions"
kic completion zsh > "$HOME/.oh-my-zsh/completions/_kic"
kubectl completion zsh > "$HOME/.oh-my-zsh/completions/_kubectl"

echo "creating k3d cluster"
kic cluster rebuild

echo "bilding IMDb"
kic build imdb

echo "building WebValidate"
sed -i "s/RUN dotnet test//g" /workspaces/webvalidate/Dockerfile
kic build webv

echo "deploying k3d cluster"
kic cluster deploy

# only run apt upgrade on pre-build
if [ "$CODESPACE_NAME" = "null" ]
then
    sudo apt-get update
    sudo apt-get upgrade -y
    sudo apt-get autoremove -y
    sudo apt-get clean -y
fi

echo "on-create complete"
echo "$(date +'%Y-%m-%d %H:%M:%S')    on-create complete" >> "$HOME/status"