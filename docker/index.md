NWS: Docker Reference
=====================

[Go up to the main NWS readme](../readme.html) ([md](../readme.md))

## Basic docker commands

| Command | description |
|---------|-------------|
| `docker-compose build` | Build the containers |
| `docker-compose up` | Run the containers |
| `docker-compose down` | Stop the containers |
| `docker pull <image>` | Download or update the specified image |
| `docker images` | See information on the docker images on your host |
| `docker ps -a` | See what containers are running |
| `docker network ls` | See the networks configured |
| `docker kill <cid>` | Kill (stop) a container |
| `docker rm <cid>` | Remove the (stopped) container |
| `docker rmi <id>` | Remove a docker image |
| `docker system prune` | Remove all killed containers and outdated images |
| `docker exec -it <cid> /bin/bash` | Start a bash shell in container `<cid>` |
| `docker login` | Login to a another docker server, if needed |
| `docker login server:5000` | Login to a another docker server, if needed |
| `docker cp <filename> <cid>:/path/to/<filename>` | Copy file into running container |
| `docker cp <cid>:/path/to/<filename> .` | Copy file from a running container into the current directory |

## Running a GUI from a docker container

### Mac OS X

Note: this has only been tested on an ARM Mac (M1/M2), and not on an Intel x64 Mac.  Reference: [this article](https://cntnr.io/running-guis-with-docker-on-mac-os-x-a14df6a76efc).

#### One-time installation

- If not installed, install Docker
	- Download and install the Mac version (appropriate for your architecture) of Docker from [docker.com/download](https://www.docker.com/get-started/)
	- Test Docker's install via `docker run hello-world` -- you should see an informative message
- Install [homebrew](https://brew.sh), if not already installed
- Install socat via `brew install socat`
- Install [xquartz](https://www.xquartz.org) via `brew install xquartz` 
	- The first time xquartz launches, go do XQuartz -> Settings -> Security, and make sure "Allow connections from network clients" is checked

#### Running the GUI

- Make sure the docker engine is running -- you should see a docker icon in the top bar (it looks like a container ship).
- Launch socat: 
    - `socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\"`
	- You can put it in the background by appending `&` to it
- Run xquartz: `open -a Xquartz`
    - You have to log out and log back in to use Xquartz
- Make sure the value of the DISPLAY variable in docker-compose.yml is set to your IP (plus `:0`)
	- This is your IP on your local network: enter `ifconfig en0` to find out what it is
	- Be sure to put the `:0` at the end of the IP address
	- Example: `DISPLAY=192.168.14.45:0` (with a `- ` before it in the docker-compose.yml file)
	- You should change this, via find-and-replace, throughout the entire docker-compose.yml file
	- If you made a change to the docker-compose.yml file, restart the containers
- Connect to a docker container (any one), and run the gui program

#### Troubleshooting

- Quick check: did you log out and then log in after installing xquartz?
- Does the Mac firewall allow socat (or socat1) to receive incoming network connections?  This is configured in System Settings -> Network -> Firewall -> Options.  You should see 'socat' (or, more likely, 'socat1') with a green 'allow incomming connections' next to it.
- If you can run the `socat` command, and `open -a Xquartz` pulls up an xterm window:
	- When connected in the docker container via `docker exec`, run `export DISPLAY=1.2.3.4:0` where 1.2.3.4 is the IP of your machine (on your LAN), then try running the GUI program again
- If you can run the `socat` command, but `open -a Xquartz` does NOT open up a window, you will need to do a full reset and restart (but not a reinstall) of the three commands used:
	- Shut down socat: `killall -9 socat` and/or `killall -9 socat1` (this may cause the xquartz window to suddenly appear)
	- Shut down xquartz via Command-Q
	- Make sure there are no processes listening to port 6000:  `lsof -i :6000`; if there are, kill them (`kill -9 <PID>`, where `<PID>` is the process value in the second column)
	- Shut down the docker containers: `docker-compose down`
	- Restart the Docker Engine -- click on the icon in the title bar, and select "restart" (there is a dialog box that asks you to confirm this, and sometimes that dialog box is hidden)
	- Do the next three steps in this exact order:
		- Start up the docker containers: `docker-compose up`
		- Start up socat: `socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\"`
		- Start up xquartz: `open -a Xquartz`
	- Connect to a docker container: `docker exec -it nws-outer1 /bin/bash`
	- Check the DISPLAY variable: `echo $DISPLAY`
		- It should be `<IP>:0`; if not, set it: `export DISPLAY=111.222.333.444:0`; change as necessary, and be sure to put the `:0` at the end
	- Run a GUI command: `xeyes`

#### Shutting down

- From the XQuartz menu, click on "Quit X11"
- Terminate socat: `killall -9 socat`


### Linux

This was tested on Ubuntu 22.04.  Reference: [this article](), but not really [this article](https://www.howtogeek.com/devops/how-to-run-gui-applications-in-a-docker-container/).

#### One-time installation

- If not installed, install Docker
	- Download and install the Linux version of Docker from [docker.com/download](https://www.docker.com/get-started/)
	- Test Docker's install via `docker run hello-world` -- you should see an informative message
- Ensure `xhost` is already installed (it probably is) -- run `which xhost` to check

#### Running the GUI

- Run `xhost +local:docker` on your host
- Make sure the value of the DISPLAY variable in docker-compose.yml is just `:0`
	- Example: `DISPLAY=:0`, with the `- ` preceeding it
	- You should change this, via find-and-replace, throughout the entire docker-compose.yml file
	- If you made a change to the docker-compose.yml file, restart the containers
- Connect to a docker container (any one), and run the gui program

#### Shutting down

- You can remove the xhost permission (via `xhost -local:docker`), but it does not seem to be a security issue if you leave it as-is



### Windows

Reference: none.  Tested on Windows 10 Pro.  Because of how WSL works, it is assumed that this will work on any recent version of Windows.


#### One-time installation

- If not installed, install WSL (Windows Subsystem for Linux).
	- You can select version 2 to install via `wsl --set-default-version 2`
	- The command to install it is `wsl --install -d Ubuntu`
	- If it hangs at 0% installation, try adding the `--web-download` flag: `wsl --install -d Ubuntu --web-download`
	- When tested, an error 0x80004002 occurred; the solution is [here](https://www.bing.com/search?pglt=43&q=wsl+error+0x80004002)
	- You launch WSL by running `wsl` in the search box
- If not installed, install Docker
	- Download the *Windows* version from [docker.com/download](https://www.docker.com/get-started/)
		- Don't try to install this through WSL!
	- During the installation, be sure to select the 'enable WSL shortcut' check box
	- Test Docker's install via `docker run hello-world` -- you should see an informative message
- In WSL, install the `xhost` program: `sudo apt install x11-server-utils`

#### Running the GUI

- Start the Docker engine -- it's the "Docker Desktop" entry in Programs
	- WSL can't use docker unless this is running
- Launch WSL; all further commands in this part are in WSL
- From this point, the directions are the same as the "Running the GUI" directions in Linux, since WSL provides a Linux shell
- Download and install the Linux version of Docker from [docker.com/download](https://www.docker.com/get-started/)
	- Run `xhost +local:docker` on your host
	- Make sure the value of the DISPLAY variable in docker-compose.yml is just `:0`
		- Example: `DISPLAY=:0`, with the `- ` preceeding it
		- You should change this, via find-and-replace, throughout the entire docker-compose.yml file
		- If you made a change to the docker-compose.yml file, restart the containers
	- Connect to a docker container (any one), and run the gui program, such as `xeyes`.

#### Shutting down

- Shut down the Docker Engine program
- In WSL, you can remove the xhost permission (via `xhost -local:docker`), but it does not seem to be a security issue if you leave it as-is
- Exit WSL if desired
