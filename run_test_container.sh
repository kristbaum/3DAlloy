#!/bin/bash

# Set container name
CONTAINER_NAME="test-mediawiki"

# Check if the container already exists
if [ $(docker ps -a -f name=$CONTAINER_NAME | grep -w $CONTAINER_NAME | wc -l) -ge 1 ]; then
  echo "Container named $CONTAINER_NAME already exists, stopping and removing it..."
  docker stop $CONTAINER_NAME
  docker rm $CONTAINER_NAME
fi

# Pull the latest MediaWiki Docker image
echo "Pulling the latest MediaWiki Docker image..."
docker pull mediawiki

# Run the MediaWiki container
echo "Running the MediaWiki container on port 8080..."
docker run --name $CONTAINER_NAME -p 8080:80 -d mediawiki

# Wait for the container to fully start and the user to complete the MediaWiki setup
echo "Waiting for the container to fully start and for you to configure MediaWiki..."
echo "Please complete the MediaWiki installation through http://localhost:8080 then press [ENTER] to continue."
read

# Enter the container and install 3DAlloy extension
echo "Installing the 3DAlloy extension..."
docker exec $CONTAINER_NAME bash -c "apt update && apt install -y unzip wget && \
                                      wget https://github.com/dolfinus/3DAlloy/archive/master.zip -O 3DAlloy.zip && \
                                      unzip 3DAlloy.zip && \
                                      mv 3DAlloy-master extensions/3DAlloy && \
                                      echo \"wfLoadExtension('3DAlloy');\" >> /var/www/html/LocalSettings.php"

echo "3DAlloy extension installed successfully."

# Restart the container to apply changes
echo "Restarting the container to apply changes..."
docker restart $CONTAINER_NAME

echo "Setup complete. Visit http://localhost:8080 to verify the installation of the 3DAlloy extension."
