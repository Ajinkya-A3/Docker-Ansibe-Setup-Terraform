output "control_node_ssh" {
  value = "ssh  -p 2222 root@localhost"
}

output "worker_ssh_commands" {
  value = [
    for i in range(2) :
    "ssh  -p ${2223 + i} root@localhost"
  ]
}



