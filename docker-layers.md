## Docker layers

The idea of combining commands in one `RUN` is to limit the Docker image layers.
Each Dockerfile command creates a layer which is essentially a Docker image on its own. Each layer builds on top of the previous layer. So each layer stores the changes to the image it is based on.

This has specifically some side effects when removing files. The files are removed from the current layer but not from the previous layer. As a result, this adds up to the total Docker image size.

The layers are used for Docker image build caching. As long as a Dockerfile line has not changed, the corresponding layer is not rebuilt. If a layer needs rebuilding, all following layers are rebuilt. This has a consequence on how to write a Dockerfile.
Usually, the things that change infrequently are put at the top (like installing Ubuntu packages, OS set up, ...) and the things that change frequently (source code) are placed at the bottom.

### Dockerfile organisation:

1. install packages
2. configuration
3. add source code or binaries for compiled languages

[This](https://dzone.com/articles/docker-layers-explained) article explains the concept of Docker image layers more in detail.