variable "ami_id" {
  type    = string
  default = "ami-03f65b8614a860c29"
}

variable "consul_server_ip" {
  type    = string
  default = "44.230.25.63"
}

locals {
    app_name = "prometheus_and_grafana_1.0.1"
}

source "amazon-ebs" "vm" {
  ami_name      = "${local.app_name}"
  instance_type = "t2.medium"
  region        = "us-west-2"
  source_ami    = "${var.ami_id}"
  ssh_username  = "ubuntu"
  tags = {
    Env  = "Dev"
    Name = "${local.app_name}"
  }
}

build {
  sources = ["source.amazon-ebs.vm"]

  provisioner "ansible" {
    playbook_file = "prometheus.yml"
    extra_arguments = [
      "--extra-vars", "consul_server_ip=${var.consul_server_ip}"
    ]
  }

  provisioner "ansible" {
    playbook_file = "grafana.yml"
  }
#command - packer build -var "consul_server_ip = <ip>" vm.pkr.hcl
}
