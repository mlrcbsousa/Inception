### Add user to sudo

```bash
$ export USERNAME=`whoami` # user should be login (msousa)
$ su -p
# /usr/sbin/usermod -aG sudo $USERNAME
# sudo reboot
```

### Install make

```bash
sudo apt-get update
sudo apt-get -y install make
```

### VirtualBox

Add user to virtualbox to use shared folder

```bash
sudo usermod -a -G vboxsf msousa
```

### Install docker and docker compose using guide on website:

- https://docs.docker.com/engine/install/debian/#install-using-the-repository

Verify installation of docker

```bash
sudo service docker start
sudo docker run hello-world
```

### Add user to docker group

```bash
sudo adduser msousa docker
sudo reboot
```

### Install firefox

```bash
sudo apt install firefox-esr
```

### Create passwords

```bash
echo -n 'my-string' | base64
```