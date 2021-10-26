# README

### Ensure dependencies are up-to-date

Periodically run the following two commands to ensure your ruby and node
dependencies are up to date:

```sh
docker-compose run web bundle install
docker-compose run web yarn install
```

### Create the development and test databases

First start up the database container:

```sh
docker-compose up --detach db
```

Then verify that the container is running:

```sh
docker-compose ps
```

The output should look like:

```txt
      Name                    Command              State    Ports
-------------------------------------------------------------------
projectname_db_1   docker-entrypoint.sh postgres   Up      5432/tcp
```

Run the following to create the database:

```sh
docker-compose run web rails db:create
```

Start up the containers:

```sh
docker-compose up
```

Then verify that the containers are running:

```sh
docker-compose ps
```

The app should be running at `http://localhost:3000/`
