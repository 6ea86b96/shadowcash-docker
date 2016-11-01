# Shadowcash Docker

A dockerized shadowcash daemon with built in fast sync, automated backups and
manual backup/restore scripts.

Wallet.dat is backed up to ~/backups/shadowcoin/wallet.dat every 12 hours.

## Usage

### Normal Usage

```bash
docker run -d -p "51737:51737" -v "$HOME/.shadowcoin:/root/.shadowcoin" -v "$HOME/backup/shadowcoin:/backup" --name shadow --restart always 0e8bee02/shadowcash-docker
```

### First Run

First run the bootstrap script. This is going setup the wallet and download
&gt;750MB of blockchain data so it will take some time.

```bash
curl https://raw.githubusercontent.com/6ea86b96/shadowcash-docker/master/bootstrap-host.sh | sh
```

Now encrypt your wallet!
```bash
docker exec -it shadow shadowcoind encryptwallet <encryption-key>
```

### Backup your wallet

```bash
docker exec -it shadow backup.sh
```

### Restore your wallet

```bash
docker exec -it shadow restore.sh
```

### Sending JSON-RPC commands

```bash
docker exec -it shadow shadowcoind <command> <args>
```
