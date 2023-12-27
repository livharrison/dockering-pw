# create data directories
if [ ! -d "../Project_Wiki_Data" ]; then
  mkdir -p ../Project_Wiki_Data/db ../Project_Wiki_Data/log ../Project_Wiki_Data/uploads ../Project_Wiki_Data/backup
fi

#until mongo --host "$DB_SERVICE" --username "$DB_USER" --password "$DB_PASS" --authenticationDatabase admin --eval "db.stats()" > /dev/null 2>&1; do
#  >&2 echo "MongoDB is unavailable - sleeping"
#  sleep 1
#done

sleep 25

python /app/run_app.py
