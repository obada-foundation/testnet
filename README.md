# Adding validators to the network

## Download [binary](https://github.com/obada-foundation/fullcore/releases/download/latest/fullcored_latest_linux_amd64) or build from source code (better option). Make sure that it is included into $PATH variable.

### Install precompiled binary

```sh
wget https://github.com/obada-foundation/fullcore/releases/download/latest/fullcored_latest_linux_amd64 -O /usr/bin/fullcored
chmod +x /usr/bin/fullcored
```

### Install from sources (Go compiler version 1.18 or more needed)

```sh
git clone https://github.com/obada-foundation/fullcore
cd fullcore/cmd/fullcored
go build .
cp fullcored /usr/bin/fullcored
```

## Initialize variables

Add variables to your `.bashrc` file or create variables in a shell session.

```sh
NODE_NAME=val-wdpi
ACCOUNT_NAME=val-wdpi
```

For consistency we use the same name just for identifying validator account. Please use prefix val, like `val-thinkdynamic` or `val-tradeloop`.

## Initialize configuration files

```sh
fullcored init $NODE_NAME --chain-id obada-testnet
```

### Where "obada-testnet" OBADA chain ID, we are still running testnet, please do not change this value.

## Create OBADA account

```sh
fullcored keys --keyring-backend test --keyring-dir ~/.fullcore/keys add $ACCOUNT_NAME
```

## Replace genesis.json file with OBADA version

```sh
wget https://raw.githubusercontent.com/obada-foundation/testnet/main/testnets/testnet-2/genesis.json -O ~/.fullcore/config/genesis.json
```

### Where "testnet-2" is a version of genesis file.

## Generate the initial balance

```sh
ADDRESS=$(fullcored keys --keyring-backend test --keyring-dir ~/.fullcore/keys show $ACCOUNT_NAME --address)

# Show account address
echo $ADDRESS

fullcored add-genesis-account $ADDRESS 1000000000000000000rohi
```

After this step, copy your local genesis file from `~/.fullcore/config/genesis.json` and send to `techops@obada.io` with title `"Genesis account: YOUR ORG NAME"` and wait for further instructions.

# Deploying a Node to the OBADA testnet

## Node minimum server requirements for the testnet

- `4 vCPU` cores (ARM64 or x64)
- Minimum `8GB` of RAM
- Storage space required to persist blockchain state and snapshots (`512GB+` recommended)
- Minimum `32GB+` of the **free** storage space available at all times (make sure that you have configured thresholds)
- Disposable cloud instance or VM
- Ubuntu `22.04 LTS` installed on the **host** instance or VM
- Stable internet connection with minimum `10 Mbps` Up/Dn speed
- Static IP address or dynamic DNS
- Access to router or otherwise your local network configuration

## Installation & deploying OBADA Node

Installation script assumes that you use **Ubuntu 20.04** for **Node**. The deployment script can be executed from any machine that can run docker, shell and makefiles. Please check [this video](https://youtu.be/is1h_RDG0C8) if you need more information about the installation details.

### Install required packages

```bash
sudo apt install docker.io make -y
```

If you don't have a **Debian** based distribution, you need to find a way to install such dependencies on your own.

### Add user to the docker group

```bash
sudo usermod -aG docker $USER
```

After execution of this command you need to reboot your provision server.

### Clone the repo

```bash
git clone https://github.com/obada-foundation/testnet
cd testnet
```

### Generate server certificates into **./ssh** folder

```bash
make certificates
```
After the success certificate generation, add **./ssh/obada_node_ssh_key.pub** to the server that you want to install the Node. Below you can find instructions how to add a key for most popular cloud/hosting providers:

- [DigitalOcean](https://docs.digitalocean.com/products/droplets/how-to/add-ssh-keys/to-account/)
- [AWS EC2](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html)
- You can also do this manually by looking into [this](https://linuxhandbook.com/add-ssh-public-key-to-server/) tutorial

### Generate **/deployment/inventory** file

```bash
make configure
```

### Deploy Node

```bash
make deploy
```

The deployment may take some time and in case of success installation, you should see a message like: 
```bash
ok: [46.101.115.172] => {
    "msg": "The Node installation was completed. If you want your Node to be included into persistent peers of the network, please send 370d82b7d013f7a0f3a6815196f871cd55367770@46.101.115.172:26656 to techops@obada.io"
}
```

## Node ports
| Port  | Purpose |
| ------------- | ------------- |
| 26656  | Used for p2p network synchronization. Must be always open.  |
| 26657  | Consensus (Tendermint) RPC endpoint. Should be closed for not trusted connections. |
| 1317  | Node REST server. Should be closed for not trusted connections. |
| 9090  | Node gRPC server. Should be closed for not trusted connections. |

