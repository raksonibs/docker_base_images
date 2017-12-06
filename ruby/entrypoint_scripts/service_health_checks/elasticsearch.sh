#!/bin/bash

# make sure ES is alive before proceeding
ES_UP=false
for i in {1..10}; do
  status=$(wget -qO- http://elastic:9200/_cat/health?h=status | tr -d [:space:])
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
