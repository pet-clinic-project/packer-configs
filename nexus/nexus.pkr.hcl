variable "ami_id" {
  type    = string
  default = "ami-03f65b8614a860c29"
}
locals {
    app_name = "nexus_1.0.1"
}

source "amazon-ebs" "nexus" {
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
  sources = ["source.amazon-ebs.nexus"]

  provisioner "ansible" {
    playbook_file = "nexus.yml"
  }

}
