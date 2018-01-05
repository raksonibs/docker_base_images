#!/bin/bash

# make sure redis is alive before proceeding
PORT=${REDIS_PORT:-6379}
REDIS_UP=false

for i in {1..10}; do
  # hack-ish way to hit redis healthcheck endpoint without redis-cli or netcat
  status=$(exec 3<>/dev/tcp/redis/$PORT && echo -e "PING\r\n" >&3 && head -c 7 <&3)
  if [[ "$status" == *"PONG"* ]]; then
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
