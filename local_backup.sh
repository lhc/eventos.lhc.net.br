#!/bin/bash

mkdir ~/gancio-backup
cd ~/gancio-backup

# Need to start container in fly.io if it was stopped by inactivity
curl -s -o /dev/null https://eventos.lhc.net.br

for filename in $(fly ssh sftp find -t $FLY_SSH_TOKEN  /data/backup/); do
	[ "$filename" == "/data/backup/" ] && continue

	base=$(basename $filename)
	rm -f $base
	fly ssh sftp get "$filename" -t $FLY_SSH_TOKEN

  # Test the archive, as the connection might be interrupted or the file might not be
  # fully generated.  If this file is skipped today, it'll be picked up tomorrow, so
  # there's no issue if there was a race condition or the connection was aborted 
  # before we could fully retrieve it.
  # However, if the file is corrupted server-side, we're not going to remove it.
	tar -tf $base || continue

  # Remove the remote file in the background
	fly ssh console -C "rm $filename" -t $FLY_SSH_TOKEN &
done

# Only leave the last 15 files in the current directory (if this script is ran once
# a day, and no files were skipped, of course).
find . -mtime +15 -name gancio_data_\* -print -delete

# Wait for all the background "rm" calls
wait
