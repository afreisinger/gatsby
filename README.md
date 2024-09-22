# Gatsby Docker Image

To build the image:

```bash
make build
```

The Docker image can be found [here](https://hub.docker.com/repository/docker/afreisinger/gatsby/general).

# Developing a Gatsby Site with Docker

## Test Site
---------

Let’s test this out using a sample Gatsby site.

    git clone https://github.com/gatsbyjs/gatsby-starter-default.git
    cd gatsby-starter-default
    

Now launch the Docker image to serve the site.

    docker run -it -p 8000:8000 -v ${PWD}:/site --name gatsby afreisinger/gatsby:latest
    

The `-it` options are not strictly required, but I find them useful because it means that I can stop the process with Ctrl-c. You also don’t need to provide a `--name` argument, but a named container is easier to reference (see below).

I’m using a pre-built version of the image from [here](https://hub.docker.com/r/afreisinger/gatsby). You can grab the underlying code [here](https://github.com/afreisinger/docker-gatsby).

Visiting [http://127.0.0.1:8000/](http://127.0.0.1:8000/) yields the test site (screenshot below).


If you want to build a production version of the site, then pass the `build` command.

    docker run -v ${PWD}:/site afreisinger/gatsby:latest build
    

The site files will be dumped to a `public` directory. You can then serve the site (you’ll find it at [http://127.0.0.1:9000/](http://127.0.0.1:9000/)).

    docker run -p 9000:9000 -v ${PWD}:/site --name gatsby afreisinger/gatsby:latest serve
    

## Debugging
---------

First launch a container with a BASH shell.

    docker run -it -v ${PWD}:/site --entrypoint /bin/bash afreisinger/gatsby:latest
    

That will launch a BASH shell in the container with `root` user.

### Compiling Typescript

Running the Typescript compiler will allow you to see any warnings and errors.

    yarn tsc
    

### Running Tests

If there are any tests then these can also be run.

    yarn test


## Docker Compose
---------

Steps to Use Docker Compose

Create a .env file in the same directory as your docker-compose.yml file to define default values for the environment variables.

```env
PORT_HOST=8000
PORT_CONTAINER=8000
```
This file allows you to set default port values which docker-compose will use if no other values are provided.

### Build and Run the Container with the Default Command:
```
docker-compose up
```

### Running Specific Commands
To run specific commands when starting the container, use docker-compose run instead of docker-compose up. Here are some examples:

Develop the Application:
```
docker-compose run gatsby develop
```

Build the Application:
```
docker-compose run gatsby build
```

Install Dependencies:
```
docker-compose run gatsby install
```

Serve the Application:
```
PORT_HOST=9000 PORT_CONTAINER=9000 docker-compose run gatsby serve
```