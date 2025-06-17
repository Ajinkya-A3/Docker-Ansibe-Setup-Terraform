
# 🚀 Ansible Docker SSH Automation with Terraform

This project provisions a full **Ansible environment** using **Terraform** and **Docker**, where:

- 🧠 An **Ansible control node** is created in a Docker container with Python & Ansible installed.
- 🛠 Multiple **worker nodes** (Docker containers) are provisioned with SSH enabled and Python installed.
- 🔐 SSH access is passwordless via **in-memory SSH key injection**, using Terraform's `tls_private_key` (no local key files).
- 🔄 Control node can execute Ansible playbooks on worker nodes.

GitHub Repo: [Ajinkya-A3/Docker-Ansibe-Setup-Terraform](https://github.com/Ajinkya-A3/Docker-Ansibe-Setup-Terraform)

---

## 📁 Project Structure

```
ansible-docker-terraform/
├── Dockerfile.control         # Installs Ansible + SSH in control node
├── Dockerfile.worker          # Installs SSH + Python in worker node
├── main.tf                    # Terraform configuration
├── terraform.tfstate          # Generated after `terraform apply`
└── README.md
```

---

## 🧰 Requirements

- [Terraform](https://www.terraform.io/downloads.html)
- [Docker](https://docs.docker.com/get-docker/)

---

## 🚦 Usage

### 1. Clone the repo

```bash
git clone https://github.com/Ajinkya-A3/Docker-Ansibe-Setup-Terraform.git
cd Docker-Ansibe-Setup-Terraform
```

### 2. Initialize Terraform

```bash
terraform init
```

### 3. Apply the Infrastructure

```bash
terraform apply -auto-approve
```

This will:

- Build custom Docker images for control and worker nodes
- Create and run containers
- Inject an in-memory SSH key into the control node and worker nodes
- Enable passwordless SSH from control → worker nodes

---

## 🧪 Test SSH Access

Once the containers are up, you can enter the **control node**:

```bash
docker exec -it control_node bash
```

Then from inside the control node, test SSH access:

```bash
ssh worker_0
ssh worker_1
```

You should get in **without password**.

---


## 🌐 Check Docker Network IPs

You can check the Docker network IP addresses using a few handy Docker commands:

### 🔍 1. List Docker Networks

```bash
docker network ls
```

Look for your network name (e.g., `ansible_net`).

### 📋 2. Inspect the Docker Network

```bash
docker network inspect ansible_net
```

This gives detailed info, including subnet, gateway, and container IPs.

#### Example Output:

```json
[
  {
    "Name": "ansible_net",
    "Id": "...",
    "Containers": {
      "e4dfd5...": {
        "Name": "control-node",
        "IPv4Address": "172.18.0.2/16"
      },
      "3d7f21...": {
        "Name": "worker-node-0",
        "IPv4Address": "172.18.0.3/16"
      }
    }
  }
]
```

---


## 📜 Ansible Inventory Example

Create this inside the control node as `/etc/ansible/hosts`:

```ini
[workers]
worker_0
worker_1
```

Then test Ansible:

```bash
ansible all -i /etc/ansible/hosts -m ping
```

---

## 🧹 Teardown

```bash
terraform destroy -auto-approve
```

---

## 💥 Tools

Built using:
- Terraform
- Docker
- Ansible

---



##  Author

- **Ajinkya-A3**
- GitHub: [@Ajinkya-A3](https://github.com/Ajinkya-A3)

---

## 📄 License

Licensed under the [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0).
