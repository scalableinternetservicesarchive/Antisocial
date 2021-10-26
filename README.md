# README

### Ensure dependencies are up-to-date

Periodically run the following two commands to ensure your ruby and node
dependencies are up to date:

```sh
docker-compose run web bundle install
docker-compose run web yarn install
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
