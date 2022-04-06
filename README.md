# Deploying a Node to the OBADA testnet

## Node minimum server requirements for the testnet

- `4 vCPU` cores (ARM64 or x64)
- Minimum `8GB` of RAM
- Storage space required to persist blockchain state and snapshots (`512GB+` recommended)
- Minimum `32GB+` of the **free** storage space available at all times (make sure that you have configured thresholds)
- Disposable cloud instance or VM
- Ubuntu `20.04 LTS` installed on the **host** instance or VM
- Stable internet connection with minimum `10 Mbps` Up/Dn speed
- Static IP address or dynamic DNS
- Access to router or otherwise your local network configuration

## Installation & deploying OBADA Node

Installation script assumes that you use **Ubuntu 20.04** for **Node**. The deployment script can be executed from any machine that can run docker, shell and makefiles. Please check [this video]() if you need more installation details.

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

### Add configuration variables for **inventory** file

```bash
cp inventory.sample inventory
```
If you are not familiar with **Ansible** inventory files and didn't watch the installation [video](), please check it.

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

