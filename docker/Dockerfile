FROM mongo:3.6.6

ARG DATA_VERSION=1.0.0

RUN mkdir -p /initdb
WORKDIR /initdb

COPY docker-entrypoint.sh .
COPY setup.sh .
COPY init_db.js .
COPY mongod.conf /etc/mongo/mongod.conf
RUN chmod +x docker-entrypoint.sh setup.sh

COPY data_${DATA_VERSION}.json birds.json

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["mongod"]
