# Singer (ETL) Pipedrive playground

Project status: Work in progress, see [issues](https://github.com/stephane-klein/singer-pipedrive-playground/issues)

## Prerequisites

On macOS, install with Brew:

```
$ brew install python
$ brew cask install docker
```

## Install and configure tap-pipedrive

```
$ python3 -m venv .venv/tap-pipedrive/
```

```
$ ./.venv/tap-pipedrive/bin/pip install https://github.com/stephane-klein/tap-pipedrive/archive/master.tar.gz
```

```
$ cp tap-pipedrive-config.json.sample tap-pipedrive-config.json
```

Put your [pipedrive](https://www.pipedrive.com/fr) API Token in `tap-pipedrive-config.json`

Generate the `pipedrive-catalog.json`:

```
$ ./.venv/tap-pipedrive/bin/tap-pipedrive -c tap-pipedrive-config.json -d > pipedrive-catalog.json
```

If you want, you can disable some selection in `pipedrive-catalog.json` file, for instance:

```
        ...
          "metadata": {
            "inclusion": "available",
            "table-key-properties": [
              "id"
            ],
            "selected": false,
            "schema-name": "notes"
          },
          "breadcrumb": []
        ...
```

## Install target-postgres

```
$ python3 -m venv .venv/target-postgres/
```

```
$ ./.venv/target-postgres/bin/pip install singer-target-postgres==0.2.4
```

## Start PostgreSQL database

```
$ ./scripts/up.sh
```

## Execute Pipedrive importation to PostgreSQL

The first time, when `state.json` don't exists, execute:

```
$ ./.venv/tap-pipedrive/bin/tap-pipedrive \
  -c tap-pipedrive-config.json \
  --catalog pipedrive-catalog.json \
  | ./.venv/target-postgres/bin/target-postgres \
    --config target_postgres_config.json \
    > state.json
```

Next execute this commands to use `state.json` [Singer State](https://github.com/singer-io/getting-started/blob/master/docs/CONFIG_AND_STATE.md) file:

```
$ ./.venv/tap-pipedrive/bin/tap-pipedrive \
  -c tap-pipedrive-config.json \
  --catalog pipedrive-catalog.json \
  -s state.json \
  | ./.venv/target-postgres/bin/target-postgres \
    --config target_postgres_config.json \
    > state-target.json
$ tail -1 state-target.json > state.json
```

Don't forget `tail...` line.

## Start Redash to visualize data

```
$ ./scripts/redash-up.sh
```

Open http://127.0.0.1:5000

- User: `admin@example.com`
- Password: `password`