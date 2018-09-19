# [jibjib-data](https://github.com/gojibjib/jibjib-data)

This repository holds the final data schemes used by a [MongoDB](https://mongodb.com) instance the [jibjib-api](https://github.com/gojibjib-jibjib-api) communicates with. It should be held in a folder indicating its version (like birds/1.0.0 or birds/1.1.0). This will then be inserted into a custom Docker container.

## Repo layout
The complete list of JibJib repos is:

- [jibjib](https://github.com/gojibjib/jibjib): Our Android app. Records sounds and looks fantastic.
- [deploy](https://github.com/gojibjib/deploy): Instructions to deploy the JibJib stack.
- [jibjib-model](https://github.com/gojibjib/jibjib-model): Code for training the machine learning model for bird classification
- [jibjib-api](https://github.com/gojibjib/jibjib-api): Main API to receive database requests & audio files.
- [jibjib-data](https://github.com/gojibjib/jibjib-data): A MongoDB instance holding information about detectable birds.
- [jibjib-query](https://github.com/gojibjib/jibjib-query): A thin Python Flask API that handles communication with the [TensorFlow Serving](https://www.tensorflow.org/serving/) instance.
- [gopeana](https://github.com/gojibjib/gopeana): A API client for [Europeana](https://europeana.eu), written in Go.
- [voice-grabber](https://github.com/gojibjib/voice-grabber): A collection of scripts to construct the dataset required for model training

## Install

The following steps describe how to build a MongoDB container with the necessary data already inserted into the database/collection birds/birds.

First clone the repo:

```
git clone https://github.com/gojibjib/jibjib-data
cd jibjib-data
```

The default version the image is built with is `1.0.0`. If you want to build another version, pass it with `--build-arg`:

```
docker build -t jibjib-data --build-arg VERSION=1.1.0 .
```

## Run

A custom `docker-entrypoint.sh` is used to configure the JibJib database. It will first check if an existing DB is mounted into `/data/db` inside the container, then check if the following environment variables are set:

- `ROOT_USER`
- `ROOT_PW`
- `READ_USER`
- `READ_PW`
- `DB`

When no database is present and the environment variables are passed to the container, a root user, as well as read-only user on the `DB` database, will be created. Also, the during image build copied data file will be inserted into the database. You can also mount a different `mongod.conf`, if wished.

You can persist the database with bind mounts or named volumes.

To start the container, run:

```
docker run -d \
    --entrypoint /initdb/docker-entrypoint.sh \
    -v $(pwd)/db:/data/db \
    -e ROOT_USER=root \
    -e ROOT_PW=root \
    -e READ_USER=read \
    -e READ_PW=read \
    -e DB=birds \
    jibjib-data
```

The `READ_USER` and `READ_PW` values are used by [jibjib-api](https://github.com/gojibjib/jibjib-api) to connect to the database. If you run jibjib-data locally and use the values from above, you need to start [jibjib-api](https://github.com/gojibjib/jibjib-api) with the environment variable `JIBJIB_DB_URL=read:read@localhost/birds`.