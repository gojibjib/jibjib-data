cat init_db.js | mongo admin
mongoimport --db __DB__ \
    --collection __DB__ \
    --file birds.json \
    -u __ROOT_USER__ \
    -p __ROOT_PW__ \
    --authenticationDatabase admin \
    --jsonArray
