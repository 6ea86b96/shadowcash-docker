# Shadowcash Docker

A dockerized shadowcash daemon with built in fast sync, tor and privoxy.
peers.dat is deleted and a new onion address is created on every restart.

## Usage

```bash
mkdir ~/.shadowcoin
docker run -d -p "51737:51737" -v "$HOME/.shadowcoin:/root/.shadowcoin" --name shadow --restart always 0e8bee02/shadowcash-docker
```

That's it! Your now running a shadowcash daemon. It will automatically start
when you start your computer.

### First Run

On the first run the container will download a zip file of the block chain so
that it can sync quickly. The zip file is over 750MB though so it'll still take
a while.

Once your daemon has finished fast syncing and started up **make sure you encrypt
it**

```bash
docker exec -it shadow shadowcoind encryptwallet <your-super-secure-password>
```

Then **backup your damn wallet.dat**. You only need to do this once. Anyone who
gets access to this file and your encryption key can access your SDC/SDT so make
sure you keep it safe!

```bash
cp ~/.shadowcoin/wallet.dat <folder-to-backup-to>
```

### Restarting your wallet

Every time it restarts you'll get a new onion address and your peers.dat will be
cleared out, for extra security.

```bash
docker restart shadow
```

### Sending JSON-RPC commands

```bash
docker exec -it shadow shadowcoind <command> <args>
```

### Protips

Setup aliases

```bash
alias sdc="docker exec -it shadow $@"
alias sdcd="docker exec -it shadow shadowcoind $@"
```

Now you can easily run shadowcoind commands without getting RSI:

```
sdcd getbalance
sdcd listtransactions
```

And you can run other commands inside the container if you need to:

```
sdc bash
```

### Running a Tor node

#### On a remote computer

It's already done :) As soon as you start up the container it updates your
iptables and is publicly accessible to the world on :51737

#### On your home computer

To do this your computer must also be accessible to the outside world on
port 51737. The instructions for how to do this are going to vary depending our
your router. But you'll basically need to do this:

Login to your router administration page (probably at [192.168.0.1](http://192.168.0.1)),
find and turn on port forwarding, then set port 51373 to forward to your
computer.

There's a simple guide on port forwarding here:
https://portforward.com/
