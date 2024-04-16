# Needed to start container in fly.io if it was stopped by inactivity
curl -s -o /dev/null https://eventos.lhc.net.br

fly ssh console -C 'sh remote_backup.sh'
fly ssh sftp get "/root/gancio_data_$(date +%F).tar.gz"
