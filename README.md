
Atelier
---

A workspace for tools and instrumentation


Getting Started
---

# using [ami-3ab1fa2d](https://console.aws.amazon.com/ec2/home?region=us-east-1#launchAmi=ami-3ab1fa2d)

```
wget -O - https://repo.saltstack.com/apt/ubuntu/16.04/amd64/latest/SALTSTACK-GPG-KEY.pub | sudo apt-key add -
echo "deb http://repo.saltstack.com/apt/ubuntu/16.04/amd64/latest xenial main" | sudo tee /etc/apt/sources.list.d/saltstack.list
sudo apt-get update
```

# master

```
sudo apt-get install salt-master
sudo apt-get install salt-ssh
sudo mkdir -p /srv/salt/deploy
git clone https://github.com/bowanddrape/haute.git /srv/salt/deploy/haute
```

# minion

```
sudo hostname haute-prod-0?
echo "haute-prod-0?" | sudo tee /etc/hostname
sudo apt-get install salt-minion
```
TODO: automate editing /etc/salt/minion to point to the right master
```
echo "$(hostname)" | sudo tee /etc/salt/minion_id
```

For micro instances
```
sudo /bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=1024
sudo chmod 0600 /var/swap.1
sudo /sbin/mkswap /var/swap.1
sudo /sbin/swapon /var/swap.1
echo "/var/swap.1 swap swap defaults 0 0" >> /etc/fstab
```
