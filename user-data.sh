#!/bin/bash
 sudo apt-get update 
 sudo apt-get install -y\
    ca-certificates \
    curl \
    gnupg \
    lsb-release
 sudo mkdir -p /etc/apt/keyrings
 curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
 echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
 sudo apt-get update
 sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin 
 sudo usermod -aG docker ubuntu
 git clone https://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@github.com/emmanuelasogwa/download.git
 cd download/infra-team-test
sudo docker compose up
