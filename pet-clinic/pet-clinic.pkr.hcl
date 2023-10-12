variable "ami_id" {
  type    = string
  default = "ami-03f65b8614a860c29"
}

locals {
    app_name = "pet-clinic-1.0.1"
}

source "amazon-ebs" "pet-clinic" {
  ami_name      = "${local.app_name}"
  instance_type = "t2.medium"
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
  default = "35.162.64.207"
}

build {
  sources = ["source.amazon-ebs.pet-clinic"]

  provisioner "ansible" {
  playbook_file = "pet-clinic-ami.yml"
  extra_arguments = ["--extra-vars", "consul_server_address=${var.consul_server_ip}"]
  }
}

