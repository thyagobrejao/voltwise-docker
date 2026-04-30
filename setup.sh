#!/bin/bash

# Definir o usuário do GitHub
GITHUB_USER="thyagobrejao"

# Lista de repositórios do ecossistema VoltWise
REPOS=(
    "voltwise-cloud"
    "voltwise-portal"
    "voltwise-ocpp"
    "voltwise-simulator"
    "voltwise-core"
    "voltwise-docs"
    "voltwise-mobile"
    "voltwise-agent"
)

echo "Iniciando a configuração do ambiente de desenvolvimento VoltWise..."

# O script assume que será executado dentro da pasta voltwise-docker.
# Vamos para o diretório pai para clonar os projetos lado a lado.
cd ..

for REPO in "${REPOS[@]}"; do
    if [ ! -d "$REPO" ]; then
        echo "Clonando $REPO..."
        git clone "git@github.com:$GITHUB_USER/$REPO.git"
    else
        echo "O diretório $REPO já existe. Fazendo pull das últimas alterações..."
        (cd "$REPO" && git pull)
    fi
done

echo "Todos os repositórios foram configurados com sucesso!"
echo "Para rodar os serviços, volte para a pasta voltwise-docker e utilize o docker-compose."
