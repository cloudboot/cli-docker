#!/bin/bash

# Configuration
EXEC_PATH=~/.cloudboot/bin
DOCKER_VOLUME=cloudboot_tmp

# Create docker volume for persisting gcloud CLI configurations
if [ ! "$(docker volume ls -q -f name=$DOCKER_VOLUME)" ]; then
    echo "Creating Docker volume: $DOCKER_VOLUME.."
    docker volume create $DOCKER_VOLUME
else
    echo "Docker volume $DOCKER_VOLUME already exists!"
fi

# Create cloudboot executable script and give it executable permissions
rm -rf "$EXEC_PATH"
mkdir -p "$EXEC_PATH"

# Cloudboot executable script content
EXEC_CONTENT="#!/bin/bash
if [ \"\$#\" -lt 1 ]; then
    docker run --rm -it -v $DOCKER_VOLUME:/home/bootstrapper/.config -v \$(pwd):/home/bootstrapper/app cloudboot
    exit 0
fi
docker run --rm -it -v $DOCKER_VOLUME:/home/bootstrapper/.config -v \$(pwd):/home/bootstrapper/app cloudboot \"\$@\"
"

# Save content to the cloudboot script
echo "$EXEC_CONTENT" > "$EXEC_PATH/cloudboot"
chmod +x "$EXEC_PATH/cloudboot"

# Add entry to bash profile
if [ ! -d "$EXEC_PATH" ]; then
    echo "Directory $EXEC_PATH does not exist. Adding line to ~/.bashrc."
    echo "export PATH=\"\$PATH:$EXEC_PATH\"" >> ~/.bashrc
    source ~/.bashrc  # Activate the changes in the current session
else
    echo "Executable path $EXEC_PATH already exists in .bashrc."
fi

echo "Excellent! Please try \"cloudboot\" now!"
