#!/bin/bash

# make sure redis is alive before proceeding
REDIS_UP=false
for i in {1..10}; do
  status=$(wget -qO- http://redis:6379/ping)
  if [ "$status" = "{\"ping\":\"PONG\"}" ]; then
    REDIS_UP=true
    break
  else
    WAIT=$(($i>5?5:$i))
    echo "Waiting $WAIT seconds for Redis to start..."
    sleep $WAIT
  fi
done

if [ $REDIS_UP = false ]; then
  echo "Unable to connect to Redis. Please make sure your Redis container is running and healthy."
  exit 1
fi
