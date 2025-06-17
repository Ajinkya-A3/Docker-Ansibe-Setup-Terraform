resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Save private key to host machine's project root

resource "local_file" "private_key_file" {
  content         = tls_private_key.ssh_key.private_key_pem
  filename        = "${path.module}/../id_rsa"
  file_permission = "0600"
}





resource "docker_network" "ansible_net" {
  name = "ansible_net"
}

resource "docker_image" "control" {
  name = "ansible-control"

  build {
    context    = "${path.module}/.."
    dockerfile = "Dockerfile.control"
  }
}

resource "docker_image" "worker" {
  name = "ansible-worker"

  build {
    context    = "${path.module}/.."
    dockerfile = "Dockerfile.worker"
  }
}

resource "docker_container" "control_node" {
  name  = "control-node"
  image = docker_image.control.name

  networks_advanced {
    name = docker_network.ansible_net.name
  }

  ports {
    internal = 22
    external = 2222
  }

  provisioner "file" {
    content     = tls_private_key.ssh_key.private_key_pem
    destination = "/root/.ssh/id_rsa"

    connection {
      type     = "ssh"
      user     = "root"
      host     = "localhost"
      port     = 2222
      password = "root"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 600 /root/.ssh/id_rsa"
    ]

    connection {
      type     = "ssh"
      user     = "root"
      host     = "localhost"
      port     = 2222
      password = "root"
    }
  }
}

resource "docker_container" "worker_nodes" {
  count = 2
  name  = "worker-node-${count.index}"
  image = docker_image.worker.name

  networks_advanced {
    name = docker_network.ansible_net.name
  }

  ports {
    internal = 22
    external = 2223 + count.index
  }

  provisioner "file" {
    content     = tls_private_key.ssh_key.public_key_openssh
    destination = "/root/.ssh/authorized_keys"

    connection {
      type     = "ssh"
      user     = "root"
      host     = "localhost"
      port     = 2223 + count.index
      password = "root"
    }
  }
}

