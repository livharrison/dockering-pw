if [ ! -d "../Project_Wiki_Data" ]; then
  mkdir -p ../Project_Wiki_Data/db ../Project_Wiki_Data/log ../Project_Wiki_Data/uploads ../Project_Wiki_Data/backup
fi

sleep 20

# start caddy
nohup caddy -conf PW_Caddyfile &>/dev/null &
if pgrep -x "caddy" > /dev/null
then
    echo "Caddy started"
else
    echo "Caddy fail to start"
fi

python /app/run_app.py
