# Mining tools for NVIDIA

This is my collection of tools to control a NVIDIA rig

Feel free to use it, learn from it, adapt it and share your learning

**OS** : lubuntu 17.10

**Motherboard** : ASRock H110 Pro BTC**+

**GPUS** : 6x 1080 and 1x 1070 ti

**Perf** : 1080 : **570** Sol/s,     1070ti : **530** Sol/s


***
## Usage

These are the binaries present in ```/crypto/tools```, which you will call most

* mine
⋅⋅⋅main script to mine manually, use -h for help
⋅⋅⋅remembers last config used, called from mining.service or used manually (multiple mining)
* mc
⋅⋅⋅ mine change : prompt a list of coins to switch mining to. (this only applies to daemon, if you are mining manually, do not use as it will respawn the daemon)
* ms
⋅⋅⋅ mine status : detailled status of mining
* mu
⋅⋅⋅ mine uptime : shows uptime of current miner (daemon)




***
## Installation (from a fresh lubuntu 17.10 installation)

### setup and get this repo
I use /crypto as placeholder (400Mb with ccminer compliled), symlink to your location or adapt the config and environment

```
sudo mkdir /crypto && sudo chown $USER:$USER /crypto
```

Download this repository :

```
sudo apt-get install git

git clone https://github.com/altagir/tools.git /crypto/tools/
```

Next, this script will install required apt packages, place some config files, install or compile miners (building ccminer is quite long) :

```
cd /crypto/tools && ./install
```

in details, the install script does :
* Create directories, log files and permissions
* Install apt packages required for tools, compiling miners and essentials
* Download and install Zcash EWFB miner 0.3.4b (binary)
* clone git of ccminer and Compile (LONG)
* install DSTM Zcash miner 0.6
* setup xorg.conf if not present (nvidia-xconfig --allow-empty-initial-configuration --enable-all-gpus --cool-bits=31 --separate-x-screens) . This step is IMPORTANT
* modify .bashrc to source some aliases in ```/crypto/tools/home/mining.aliases```
* modify /etc/crontab to add rule to periodically launch ```/crypto/tools/mcheck-service```
* install ```/etc/mining.conf```
* install a logrotate rule  ```/etc/logrotate.d/mining```
* install the daemon ```/etc/systemd/system/mining.service```
* install a motd (shows what is currently mining at login) ```/etc/update-motd.d/99-mining```





### Additional Steps:

#### finishing postfix installation

I used satellite when asked during postfix package installation then edited /etc/postfix/main.cf :

```
myhostname = mymachinename
relayhost = [smtp.myprovider.com]:25
mydestination = $myhostname, mymachinename, localhost.localdomain, localhost
```

## Adapting the config

### /etc/mining.conf

In Bold are the ones you NEED to customize, else you will mine for me. 

PARAM | DEFAULT | NOTE
---   | ---     | ---
TOOLS_PATH | /crypto/tools | this repository location
MINER_PATH | /crypto/miners | where to place the miners binaries
**MINER_ID**   |  | Login to use when authentication is required. This should not be a crypto address. If you use different credentials or password, just adapt MINERS below
**MINER_PASS** | x | Password for sites
**EMAIL_NOTIF** | | “yourgmail@gmail.com” or user login
INTENSITY | 21 | [8.0-25] Just apply to ccminer. Max intensity differs from algo to algo, so put the max that doesn’t crash your GPU
IDLE_GPU  | 35 | was 75 until I met a funny algo. If 2 GPUs go under that percentage of intensity, daemon will be restarted. mcheck_service does that check, and is called from crontab
**COINS_PRICES** | | Space separated list of crypto symbols. Used by prices and pricess scripts to fetch current price of these symbols
MINERS PARAM section | | Adapt to fit your need, request more miners if you wish
**SUB_x_x** | | For each of them, adapt your username and password. Customize as you want with other pools (change server and port)



If you like these tools, fee free to contribute to one of my addresses in mining.conf or let it run a few hours on your rig.

Please send me feedback and change request



[DSTM miner 0.6](https://bitcointalk.org/index.php?topic=2021765.0) is provided in this repo
