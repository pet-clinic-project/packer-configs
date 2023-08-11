variable "ami_id" {
  type    = string
  default = "ami-0735c191cf914754d"
}

locals {
    app_name = "Prometheus"
}

source "amazon-ebs" "nginx" {
  ami_name      = "${local.app_name}"
  instance_type = "t2.micro"
  region        = "us-west-2"
  source_ami    = "${var.ami_id}"
  ssh_username  = "ubuntu"
  tags = {
    Env  = "DEMO"
    Name = "${local.app_name}"
  }
}

variable "consul" {
  type = object({
    server = object({
      ip = string
    })
  })
}

build {
  sources = ["source.amazon-ebs.nginx"]

  provisioner "ansible" {
    playbook_file = "prometheus.yml"
    extra_arguments = [
      "--extra-vars", "consul_server_address=${var.consul.server.ip}"
    ]
  }

  provisioner "ansible" {
    playbook_file = "grafana.yml"
  }
#command - packer build -var "consul.server.ip = <ip>" vm.pkr.hcl
}
