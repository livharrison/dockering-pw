# Containerized Project Wiki

This is a Dockerized version of Project Wiki originally developed by Hua Gong. __To see the original Project Wiki codebase and read its documentation, please see [Hua's original repo](https://github.com/GNHua/Project-Wiki/tree/master).__ This version was developed during 2023-2024 to make Project Wiki more portable (since currently, several of its software dependencies & the mongo version are too old to install).

### Docker Overview

![Basic diagram showing the two Docker containers and which scripts they call.](/container-diagram.png)

There are two Docker containers; one for the MongoDB database and one for the Project Wiki app. Each will call different scripts (see diagram above for a quick overview). The app container also references files uploaded into your project wiki instance as a volume. The `docker-compose.yml` file connects these two containers together. 

### Set Up With Example Instance

Clone this repo onto your local machine. If you want to use the provided test instance you'll need to download that as well. It can be found [here](https://github.com/livharrison/sample-project-wiki).

There are several places within the code you'll need to modify in order to properly restore a Project Wiki instance. In any case, you need to have on hand:

- the names of the databases to restore
	- there is always an `admin` database, and an additional database for every group in Project Wiki
- the database username and password (created when you ran [setup.sh](https://github.com/GNHua/Project-Wiki/blob/master/macosx/setup.sh))
- the Project_Wiki_Data folder (specifically `dump` and `uploads` directories)

--------------

#TODO main files to change may include docker-compose.yml, setup-mongo.sh, mongo.dockerfile


How to Add Your Own Data:
- The `app` dir, dir containing your mongodump'ed db, scripts, and dockerfiles should all be in the same layer
- define where your data you want restored is on line 11 of mongo.dockerfile
- define which dbs you need restored inside of setup-mongo.sh
- define db username & password in the environment variables of docker-compose.yml

### Run

You need to have Docker installed on your machine. I installed [Docker Desktop](https://www.docker.com/products/docker-desktop/). Any time you want to run Project Wiki, you need to open up Docker Desktop. If you don't, your build will fail with the error message that the Docker daemon is not running.

- Open Docker Desktop (or otherwise start the daemon)
- In your terminal, run `docker-compose build`
	- for a very small example instance of Project Wiki, this takes about one minute to run to completion for me
- Run `docker-compose up`
	- according to my knowledge, after running the build command the first time, you only need to run it again if you edit a file that is NOT `docker-compose.yml`, `mongo.dockerfile`, or `app.dockerfile`. Otherwise, you should be able to just run `docker-compose up`
	- _You may have to wait a bit here. You should see a bunch of status updates from the `mongo` container telling you what it's doing. Once you see the_ `Caddy started` _message from the project container, the app should be loaded to the point where you can open it in the browser._
- Open 127.0.0.1:31415, 0.0.0.0:31415, or localhost:31415 in a browser
- Voila! To shut it down, you can Cmd-C in your terminal, or hit the container's stop button in the Docker desktop GUI application.