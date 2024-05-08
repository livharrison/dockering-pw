# Containerized Project Wiki

This is a Dockerized version of Project Wiki originally developed by Hua Gong. __To see the original Project Wiki codebase and read its documentation, please see [Hua's original repo](https://github.com/GNHua/Project-Wiki/tree/master).__ This version was developed during 2023-2024 to make Project Wiki more portable (since currently, several of its software dependencies & the mongo version are too old to install).

### Docker Overview

![Basic diagram showing the two Docker containers and which scripts they call.](/container-diagram.png)

There are two Docker containers; one for the MongoDB 3.4 database and one for the Project Wiki app (using Python 3.6). Each will call different scripts (see diagram above for a quick overview). The app container also references files uploaded into your project wiki instance as a volume. The `docker-compose.yml` file connects these two containers together. 

### Set Up With Example Instance

Clone this repo onto your local machine. If you want to use the provided test instance you'll need to download that as well. It can be found [here](https://github.com/livharrison/sample-project-wiki) - note that this is just the contents of the `Project_Wiki_Data` directory.

There are several places within the code you'll need to modify in order to properly restore a Project Wiki instance. In any case, you need to have on hand:

- the names of the databases to restore
	- there is always an `admin` database, and an additional database for every group in Project Wiki. This is how Mongo works - there are always at least two dbs.
- the database username and password (created when you ran [setup.sh](https://github.com/GNHua/Project-Wiki/blob/master/macosx/setup.sh))
- the`Project_Wiki_Data` folder (specifically `backup` and `uploads` directories)

If you're using the provided test instance, the database username and password are __user1__ and __password123__. The admin (user) username and password are __admin__ and __password234__.

Now add some key information to these files as follows:

- [config.py](https://github.com/livharrison/dockering-pw/blob/main/config.py)
	- add the database username and password to `MONGODB_SETTINGS` (lines 15-16)
		- again, if you're using the provided PW instance, this is 'user1' and 'password123'
	- add the admin username and password to `ADMIN_USERNAME` and `ADMIN_PASSWORD` respectively (lines 35, 37)
		- for the provided instance, this is 'admin' and 'password234'
	- these should be wrapped in single quotes
- [docker-compose.yml](https://github.com/livharrison/dockering-pw/blob/main/docker-compose.yml)
	- set up the volume for the backup data to the mongo container. In the `volumes` section of the `mongo` container settings (line 10-11), add the absolute path to the _backup directory_ on your machine. The stuff on the right side of the colon is the location in the container. Make sure it matches `MONGO_DATA_DIR` on lines 15 and 30.
		- NOTE: the `backup` directory itself is a parent directory which can contain zero to many backups. You need to specify which subdirectory within it you want to restore. In the case of the sample instance, I only backed it up once, so there is just one backup in that directory.
	- add the volume for the file uploads to the app container (line 28). This will be  similar to the backup path, except it needs to be the absolute path to the `uploads` directory within `Project_Wiki_Data`. The right side of the colon tells us that when we start the docker container, we should be able to see the file uploads in `/app/uploads`.
- [mongo.dockerfile](https://github.com/livharrison/dockering-pw/blob/main/mongo.dockerfile)
	- add environment variables on lines 14-16. These should match what you just put into the config and docker-compose file, and don't need to be wrapped in single quotes
	- these may be redundant, but I'm not exactly sure which environment variables are referenced where, so just go with it for now
- [setup-mongo.sh](https://github.com/livharrison/dockering-pw/blob/main/setup-mongo.sh)
	- after line 21, you need to define which databases you want restored, since we run a separate `mongorestore` command for each database. There will always be an `admin` database, and each additional group in Project Wiki has its own database. So if you had three separate groups, you'd need to copy that `mongorestore` command four times - once for `admin`, and once for each of the three groups
		- an easy way to tell which databases you have is to go to your backup and see which directories are in it
	- you can seriously just copy and paste the whole command and replace the last two instances of `admin`. So if we want to restore our admin database and a database of a group called Food, our command will look like this:

```
mongorestore --drop --host 127.0.0.1 --port 27017 --authenticationDatabase admin \
    --username $DB_USER --password $DB_PASS --db admin /data/db/backup/admin
mongorestore --drop --host 127.0.0.1 --port 27017 --authenticationDatabase admin \
    --username $DB_USER --password $DB_PASS --db Food /data/db/backup/Food
```

- `mongorestore` will fail unless authenticated, so we add in `--authenticationDatabase admin` and the database username/password
- note: for restoring a very large database, you may need to add another `sleep` command after these so that the app doesn't try to restart before the data has been restored. I haven't tested this out, so I don't know, but that's my hypothesis.
- another note: if you want to delete the comments in this file, feel free to, but do __not__ delete the first line `#!/bin/bash`. This is called the _shebang_, and the script doesn't work without it.

Note on host and port: Project Wiki's database currently defaults to 127.0.0.1:27017. I did not go through and change every instance of this to use the environment variables, because that is how it was originally set up (but that would probably be a good idea in the future). If you want to change this, be make sure you're thorough - you'll have to change it in multiple scripts & files. The same can be said for the default server location, 127.0.0.1:31415.


### Run

You need to have Docker installed on your machine. I installed [Docker Desktop](https://www.docker.com/products/docker-desktop/). Any time you want to run Project Wiki, you need to open up Docker Desktop. If you don't, your build will fail with the error message that the Docker daemon is not running.

- Open Docker Desktop (or otherwise start the daemon)
- Make sure you're inside the `dockering-pw` directory; in other words, you should be at the same level as all the dockerfiles and the docker-compose file
- In your terminal, run `docker-compose build`
	- for me, this typically takes about 1 - 1.5 minutes to run to completion
- Run `docker-compose up`
	- according to my knowledge, after running the build command the first time, you only need to run it again if you edit a file that is NOT `docker-compose.yml`, `mongo.dockerfile`, or `app.dockerfile`. Otherwise, you should be able to just run `docker-compose up`
	- _You may have to wait a bit here. You should see a bunch of status updates from the `mongo` container telling you what it's doing. Once you see the_ `Caddy started` _message from the project container, the app should be loaded to the point where you can open it in the browser._
- Open 127.0.0.1:31415, 0.0.0.0:31415, or localhost:31415 in a browser
- Voila! To shut it down, you can Cmd-C in your terminal, or hit the container's stop button in the Docker desktop GUI application.
- For sample PW:
   - Login in with u: __admin__ p: __password234__.
   - There's just one group on the sample database - Food. You should be able to see all three pages, titled 'Home', 'Recipes', and 'Vegetables'. Recipes has a link to a PDF recipe book. Vegetables has photos and descriptions of five vegetables. If you set up the `uploads` volume correctly, you should be able to view all the images and download the PDF.