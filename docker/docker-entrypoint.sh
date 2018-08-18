#!/usr/bin/env bash
set -e

BIRD_FILE="birds.json"
INITDB_DIR="/initdb"
DATA_DIR="/data/db"
INIT_JS="init_db.js"
INIT_SH="setup.sh" 

# Security cleanup
function cleanup {
    rm $INIT_JS $INIT_SH
    unset $ROOT_USER $ROOT_PW $DB $READ_USER $READ_PW
}

# Only run routine if no DB present
if [ -z $(ls -A $DATA_DIR)]; then
    echo "No database found in $DATA_DIR , running JibJib init routine..."

    # Check if necessary ennvironment variables have been set
    : "${ROOT_USER?"Aborting: ROOT_USER not set"}"
    : "${ROOT_PW?"RAborting: ROOT_PW not set"}"
    : "${READ_USER?"Aborting: READ_USER not set"}"
    : "${READ_PW?"Aborting: READ_PW not set"}"
    : "${DB?"Aborting: DB not set"}"

    # Substituting parameters
    sed -i "s/__ROOT_USER__/$ROOT_USER/g" $INIT_JS $INIT_SH
    sed -i "s/__ROOT_PW__/$ROOT_PW/g" $INIT_JS $INIT_SH
    sed -i "s/__DB__/$DB/g" $INIT_JS $INIT_SH
    sed -i "s/__READ_USER__/$READ_USER/g" $INIT_JS
    sed -i "s/__READ_PW__/$READ_PW/g" $INIT_JS

    # Check if birds.json is present in /initdb
    if [ ! -f birds.json ]; then
        echo "Aborting: $INITDB_DIR/$BIRD_FILE not present"
        exit 1
    fi
    
    # Start mongo for init 
    mongod --fork --syslog --config /etc/mongo/mongod.conf

    # Running init script
    ./$INIT_SH

    # Exit mongo
    kill $(pgrep mongo)

    echo "Mongo init routine finished successfully"
    cleanup
    sleep 4

    exec "$@"
fi
