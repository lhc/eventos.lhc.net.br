#!/bin/bash

# Need to start container in fly.io if it was stopped by inactivity
curl -s -o /dev/null https://eventos.lhc.net.br

filename="gancio_data_$(date +%F).tar.gz"
fly ssh console -C 'tar cvz /data' -t $FLY_SSH_TOKEN > $filename
