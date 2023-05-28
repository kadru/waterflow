# Waterflow

## Requirements

- ruby 3.1.x
- node 14.x
- redis 6.x
- postgresql 11
- Docker ~> 24
- Docker compose ~> 1.29

## Setup project environment variables

1. Copy `env.development.example` to `env.development.local` and `.env.test.example` to `.env.test.local`

    ```bash
    cp env.development.examplet .env.development.local && cp env.test.example .env.test.local
    ```

2. Change the values for appropiate ones.

## Setup database

### With docker-compose

1. Copy `compose.example` and `.postgres.env` to `.compose.env` and `.postgres.env`.

    ```bash
    cp compose.example .compose.env && cp postgres.example .postgres.env
    ```

2. Change the values of the variables for appropiate ones. For example choose a more secure password for postgres and choose and port that make no conflict with local setup

3. Start the containers

    ```bash
    sudo docker-compose --env-file .compose.env up
    ```
