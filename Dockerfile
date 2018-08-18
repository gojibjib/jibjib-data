FROM mongo:3.6.6

ARG DATA_VERSION=1.0.0

RUN mkdir -p /initdb
WORKDIR /initdb

COPY docker/docker-entrypoint.sh .
COPY docker/setup.sh .
COPY docker/init_db.js .
COPY docker/mongod.conf /etc/mongo/mongod.conf
RUN chmod +x docker-entrypoint.sh setup.sh

COPY birds/${DATA_VERSION}/data_${DATA_VERSION}.json birds.json

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["mongod"]
