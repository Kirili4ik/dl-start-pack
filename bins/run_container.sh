#!/bin/bash

image_name=ht1
project_name=ht1_project
username=$(whoami)
container_name=${username}-${image_name}

docker stop "${container_name}"
docker rm "${container_name}"

docker run -it \
    --gpus all \
    --net=host \
    --ipc=host \
    --detach \
    -v /home/"${username}"/"${project_name}":/"${project_name}" \
    -v /home/"${username}"/data:/data \
    --workdir /"${project_name}" \
    --name "${container_name}" \
    --entrypoint /bin/bash \
    ${image_name}
