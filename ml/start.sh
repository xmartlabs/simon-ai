#!/bin/bash
docker run --rm -it -u $(id -u):$(id -g)  --network host  -v $PWD/models:/app/models -v $PWD/src:/app/src -v $PWD/datasets:/app/datasets -v $HOME/clearml.conf:/clearml.conf simon_ai

# uncomment for gpu
# docker run --rm -it -u $(id -u):$(id -g) --gpus all -p 5000:5000 -p 8888:8888 -v $PWD/models:/app/models -v $PWD/src:/app/src -v $PWD/datasets:/app/datasets PROJECT_IMAGE_NAME