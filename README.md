# Calendar - Laboratório Hacker de Campinas

## Data Backup

We use SQLite as database because this is not a website that will have a
significant traffic, so keeping all the data in the filesystem is enough.

[Volumes](https://fly.io/docs/reference/volumes/) are used to store
the database, uploaded files and logs. fly.io performs
[regular snapshots](https://fly.io/docs/flyctl/volumes-snapshots/) that can
be used as one source of backups. However, if we want to download the content of
the volume to our local computer we need to execute the following steps:

- In your local machine, access the application shell using the command:

```
fly ssh console -C bash
```

- The data we want to download is mounted in `/data/` directory. Run the following command
to generate a file containing all the content of this directory:

```
tar czf "/root/gancio_data_$(date +%F).tar.gz" /data
```

- Disconnect from the app and in your local machine run the following command to download the file
you generated:

```
fly ssh sftp get "/root/gancio_data_$(date +%F).tar.gz"
```
