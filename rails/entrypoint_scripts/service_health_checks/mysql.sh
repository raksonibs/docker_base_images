# if MYSQL_HOST is present, make sure mysql is alve before proceeding
if [ ! -z "${MYSQL_HOST}" ]; then
  MYSQL_UP=false
  for i in $(seq 1 10); do
    if mysqladmin ping -h ${MYSQL_HOST} --silent > /dev/null; then
      MYSQL_UP=true
      break
    else
      sleep 1
    fi
  done

  if [ $MYSQL_UP = "false" ]; then
    echo "Unable to connect to database. Please make sure your ${MYSQL_HOST} container is running and healthy."
    exit 1
  fi
fi
