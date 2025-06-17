output "control_node_ssh" {
  value = "ssh -i id_rsa -p 2222 root@localhost"
}

output "worker_ssh_commands" {
  value = [
    for i in range(2) :
    "ssh -i id_rsa -p ${2223 + i} root@localhost"
  ]
}

output "private_key_pem" {
  value     = tls_private_key.ssh_key.private_key_pem
  sensitive = true
}

