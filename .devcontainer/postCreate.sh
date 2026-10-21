#!/usr/bin/env bash
set -euo pipefail

ruby -v
sudo rm -f /etc/apt/sources.list.d/yarn.list /etc/apt/sources.list.d/yarn*.list
sudo apt-get update
sudo apt-get install -y graphviz default-jre-headless
sudo gem update --system 4.0.5
gem install bundler -N
gem install debug rubocop -N