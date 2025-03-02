#!/bin/bash

set -x

export DEBIAN_FRONTEND=noninteractive
sudo apt-get update
sudo apt-get --yes upgrade

echo "export EDITOR=vim" >> ~/.bashrc

# Install Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
usermod -aG docker vagrant

# Install build essentials
sudo apt-get install --yes build-essential

# Install rbenv https://github.com/rbenv/rbenv#installation
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
cd ~/.rbenv && src/configure && make -C src
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init - bash)"' >> ~/.bashrc
# Install rbenv-build plugin for `rbenv install` command https://github.com/rbenv/ruby-build#installation
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - bash)"
mkdir -p "$(rbenv root)"/plugins
git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build

# Install Java SE as a prerequisite for JRuby.
# Use the same version as in Logstash Dockerfile https://github.com/elastic/logstash/blob/37e1db0c129c03cfd7b724775d26a06eb5a1fe39/Dockerfile#L5.
sudo apt install --yes openjdk-11-jdk-headless

# Install JRuby and Bundler.
cd /sumologic
rbenv install
gem install bundler
