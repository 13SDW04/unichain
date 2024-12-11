#!/bin/bash

# Обновляем систему
sudo apt update && sudo apt upgrade -y

# Устанавливаем Docker
sudo apt install -y docker.io

# Устанавливаем Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Клонируем репозиторий Unichain
git clone https://github.com/Uniswap/unichain-node

# Переходим в директорию unichain-node
cd unichain-node

# Редактируем конфигурацию .env.sepolia
CONFIG_FILE=".env.sepolia"
if [ -f "$CONFIG_FILE" ]; then
  sed -i 's|^OP_NODE_L1_ETH_RPC=.*|OP_NODE_L1_ETH_RPC=https://ethereum-sepolia-rpc.publicnode.com|' "$CONFIG_FILE"
  sed -i 's|^OP_NODE_L1_BEACON=.*|OP_NODE_L1_BEACON=https://ethereum-sepolia-beacon-api.publicnode.com|' "$CONFIG_FILE"
else
  echo "Файл $CONFIG_FILE не найден. Убедитесь, что вы находитесь в правильной директории."
  exit 1
fi

# Запускаем ноду
docker-compose up -d

# Проверяем ноду с помощью curl
curl -d '{"id":1,"jsonrpc":"2.0","method":"eth_getBlockByNumber","params":["latest",false]}' \
  -H "Content-Type: application/json" http://localhost:8545
