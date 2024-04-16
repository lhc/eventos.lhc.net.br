# Calendar - Laboratório Hacker de Campinas

Configuration files of [https://eventos.lhc.net.br](https://eventos.lhc.net.br) - the
public calendar of all events and activities of LHC. It uses [Gancio](https://gancio.org/)
and it is accessible to any person that wants to schedule some activity or event in the
hackerspace.

If you want to use it in your own organization, you can use this repository and
[this blog post](https://rennerocha.com/posts/configuring-self-hosted-calendar-for-small-community/)
as reference. Also, you can keep in touch with LHC members to get more info how to manage it.

## Deployment

The application is running in a [fly.io](https://fly.io/) account. If you are planning to upgrade it,
ask some member of LHC board to get access credentials.

### Authentication

Before start using [fly.io](https://fly.io/), you need to authenticate with the right credentials. Use
the command bellow and follow the instructions:

```
$ flyctl auth login
```

### Production Deploy

When everything is configured as desired, deploy to production using the command:

```
flyctl deploy --verbose
```

### Status

This command will show the status of the application:

```
flyctl status
```

This command will show the logs of the application:

```
flyctl logs
```

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

## Upgrading Gancio

Watch [gancio.org](https://gancio.org/changelog) page to know when a new version is available. Before
upgrading it, create a local backup of `/data/` directory in your local machine following the instructions
of the previous section.

The [Dockerfile](https://github.com/lhc/eventos.lhc.net.br/blob/main/Dockerfile#L7) used, gets the latest version
of Gancio, so you just need to redeploy the application in [fly.io](https://fly.io/) and we should have the
new version applied correctly.

If you want to redeploy a specific version (e.g. to revert the upgrade), change the content of the
[Dockerfile](https://github.com/lhc/eventos.lhc.net.br/blob/main/Dockerfile#L7) to fetch the desired
version.