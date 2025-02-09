Notes for Setting up the environment

#### Create SSH key to connect to VM in the cloud

Check [Createh SSH Key](https://cloud.google.com/compute/docs/connect/create-ssh-keys)

In Git Bash we run:

`ssh-keygen -t rsa -f ~/.ssh/gcp -C pica_gcp`

Where *pica_gcp* is the user of the VM machine will connect to.

Put public key to GCP in:

`compute_engine > metadata > ssh keys`

All the VM within the GCP project will have the same keys.

#### Create VM

- Name: de-zoomcamp
- Region: europe-southwest1 (Madrid)
- General purpose
- VM Type: E2 e2-standard-4 (USD 116.65 per month)
- OS and Boot disk: Ubuntu 20.04 LTS, 30Gb


#### Connect to VM

From home directory:

`ssh -i ~/.ssh/gcp pica_gcp@34.175.59.212`

Make sure you are using the correct user you pu in the key when generated.

#### Configure instance

In the video Anaconda is installed (for Linux)

Create config file in your computer. Configure access to the server (VM)

From `~/.ssh` execute `touch config` and edit with `code config` (or any other editor):

```bash
Host de-zoomcamp
    HostName 34.175.59.212
    User pica_gcp
    IdentityFile c:/Users/apica/.ssh/gcp
```

Now you will be able to jump into the VM with just:

`ssh de-zoomcamp`

Useful commands:

- `less bashrc`: Check file that is executed everytime we log-in into the machine. 
- `logout`: Logout from the machine and go back to terminal.
- `source .bashrc`:  This will apply changes without the need to logout and login back.

Install dependencies:

`sudo apt-get update`

##### Docker

- `sudo apt-get install docker.io`
- Give permissions to Docker followin [this link](https://github.com/sindresorhus/guides/blob/main/docker-without-sudo.md):
  - sudo groupadd docker
  - sudo gpasswd -a $USER docker
  - sudo service docker restart
  - logout and logback
  - Test `docker run hello-world`
  - Test `docker run -it ubuntu bash` , do `ls` and `exit`
- Install Docker Compose
  - Go to [Docker Compose Repo](https://github.com/docker/compose)
  - Select the last release
  - Pick the corresponding version `docker-compose-linux-x86_64` and copy the link
  - Create in root of the VM the dir `make dir bin/` where all executable files will go
  - `cd` to `bin/` and run `wget https://github.com/docker/compose/releases/download/v2.32.4/docker-compose-linux-x86_64 -O docker-compose`
  - The file is executable but the system do not know. Make it executable with `chmod +x docker-compose`. It should have gone from black to green with listed with `ls`
  - Make it vissible from any directory by adding it to the PATH variable:
    - Open .bashrc file with: `nano .bshrc`
    - Add at the bottom: `export "PATH="${HOME}/bin:${PATH}"`
    - Ctrl+O to save + Enter + Ctrl+X to exit the editor.
    - Run `source .bashrc`

##### Package management

In the Data engineeroing Zoomcamp it is recommended to manage dependencies with Anaconda.

Here we will try to go on with Poetry

The Ubuntu VM should have python 3.7 or higher. Validate by:

`python3 --version`

Install poetry:

If this command does not work, verify system python version is 3.9 or higher or install python 3.9 with:

`sudo apt install python3.9`

Then run:

`curl -sSL https://install.python-poetry.org | python3.9 -`

Verify Poetry installation with `poetry --version`

If there are problems with Poetry it is good to use pyenv to manage different Python versions:

```bash
# Install pyenv
curl https://pyenv.run | bash

# Install Python 3.10 via pyenv
pyenv install 3.10.13

# Set for current project
cd your-project
pyenv local 3.10.13
poetry install
```

#### Clone the github repository

`git clone https://github.com/DataTalksClub/data-engineering-zoomcamp.git`


#### Configure VSCode to access Machine

Use VSCode to work instead of on the laptop on the VM:

Install Extension Remote - SSH

You have different methd to initiate a remote session:

- Left bar menu: Remote Explorer icon
- Bottom left icon 'Open a Remote Window'
- Command Palette -> Type "Remote SSH"

With any of them as we created the `~/.ssh/config` file we will see the host `de-zoomcam` available

##### Jupyter Notebook in Remote VS Code

In Remote connections with VSCode not all the extensions are installed. Just some of them. To run Jupyter Notebooks from within VSCode you will need to install manual two extensions: Python and Jupyter.

#### Configura ports 

In the VM we have a container running postgress in port 5432. To work locally with the postgres we need to configure ports.
Go to Ports in VSCode and add 5432 and 8080.
From windows machine (or local laptop) we should be able to access both the postgress in port 5432 and the pgAdmin in port 8080.
Also for Jupyter Notebooks we might want to use port 8888.

##### Terraform

Go to /bin within VM

```bash
wget https://releases.hashicorp.com/terraform/1.10.5/terraform_1.10.5_linux_amd64.zip
sudo apt-get install unzip
unzip terraform_1.10.5_linux_amd64.zip
rm terraform_1.10.5_linux_amd64.zip
```

Put the json files credentials to VM Server. To transfer files between local laptop and VM server we can use sftp

``` bash
sftp de-zoomcamp
mkdir .gc
cd .gc
put de-zoomcamp.json
```

#### Google CLI auth

```bash
export GOOGLE_APPLICATION_CREDENTIALS=~/.gc/de-zoomcamp.json
gcloud auth activate-service-account --key-file $GOOGLE_APPLICATION_CREDENTIALS
```

#### Stop VM

- Stop from the GCP Console to resume later (It will not charge computational power but will charge storage)
- Stop from the terminal: `sudo shutdown now`
Delete to destroy it

#### Restart VM

- When the VM is started we need to update the .ssh/config file with the new External IP