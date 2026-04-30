#!/bin/bash

# Define the GitHub user
GITHUB_USER="thyagobrejao"

# List of repositories in the VoltWise ecosystem
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

echo "Starting VoltWise development environment setup..."

# The script assumes it will be executed inside the voltwise-docker folder.
# Go to the parent directory to clone the projects side-by-side.
cd ..

for REPO in "${REPOS[@]}"; do
    if [ ! -d "$REPO" ]; then
        echo "Cloning $REPO..."
        git clone "git@github.com:$GITHUB_USER/$REPO.git"
    else
        echo "The directory $REPO already exists. Pulling the latest changes..."
        (cd "$REPO" && git pull)
    fi
done

echo "All repositories have been successfully set up!"
echo "To run the services, go back to the voltwise-docker folder and use docker-compose."
