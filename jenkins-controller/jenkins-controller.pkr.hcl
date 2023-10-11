variable "ami_id" {
  type    = string
  default = "ami-03f65b8614a860c29"
}

variable "jenkins_version" {
  type    = string
  default = "2.387.1"
}

locals {
  app_name = "jenkins_controller_1.0.1"
}

source "amazon-ebs" "jenkins" {
  ami_name           = local.app_name
  instance_type      = "t2.medium"
  region             = "us-west-2"
  availability_zone  = "us-west-2a"
  source_ami         = var.ami_id
  ssh_username       = "ubuntu"
  tags = {
    Env  = "dev"
    Name = local.app_name
  }
}

build {
  sources = ["source.amazon-ebs.jenkins"]

  provisioner "ansible" {
    playbook_file     = "jenkins-controller.yaml"
    extra_arguments   = ["--extra-vars", "jenkins_version=${var.jenkins_version}"]
    ansible_ssh_extra_args = "-oHostKeyAlgorithms=ssh-rsa"
  }
}
