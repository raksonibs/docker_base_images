#!/bin/bash

# make sure ES is alive before proceeding
if [ ! -z "${ELASTICSEARCH_HOST}" ]; then
  PORT=${ES_PORT:-9200}
  ES_UP=false
  for i in {1..10}; do
    status=$(wget -qO- http://$ELASTICSEARCH_HOST:$PORT/_cat/health?h=status || echo "failed" | tr -d [:space:])
    if [ "$status" = "yellow" ] || [ "$status" = "green" ]; then
      ES_UP=true
      break
    else
      WAIT=$(($i>5?5:$i))
      echo "Waiting $WAIT seconds for Elasticsearch to start..."
      sleep $WAIT
    fi
  done

  if [ $ES_UP = false ]; then
    echo "Unable to connect to Elasticsearch. Please make sure your Elasticsearch container is running and healthy."
    exit 1
  fi
else
  echo "ELASTICSEARCH_HOST is not set. Skipping ES healthcheck."
fi
