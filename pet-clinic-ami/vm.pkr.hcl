variable "ami_id" {
  type    = string
  default = "ami-0735c191cf914754d"
}

locals {
    app_name = "pet-clinic-1.0.0"
}

source "amazon-ebs" "nginx" {
  ami_name      = "${local.app_name}"
  instance_type = "t2.micro"
  region        = "us-west-2"
  source_ami    = "${var.ami_id}"
  ssh_username  = "ubuntu"
  iam_instance_profile = "instance_role"
  tags = {
    Env  = "DEMO"
    Name = "${local.app_name}"
  }
}

variable "consul_server_ip" {
  type    = string
  default = ""
}

build {
  sources = ["source.amazon-ebs.nginx"]

  provisioner "ansible" {
    playbook_file = "ami.yml"
    extra_arguments = [
    "--extra-vars", "consul_server_address=${var.consul_server_ip}",
    "--scp-extra-args", "'-O'",
    "--ssh-extra-args", "-o IdentitiesOnly=yes -o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedAlgorithms=+ssh-rsa"
    ]
  }
}
  

