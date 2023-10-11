variable "ami_id" {
  type    = string
  default = "ami-0f4e949f4afa4e5a9"
}

locals {
    app_name = "jenkins_agent_1.0.1"
}

source "amazon-ebs" "jenkins-agent" {
  ami_name      = "${local.app_name}"
  instance_type = "t2.micro"
  region        = "us-west-2"
  source_ami    = "${var.ami_id}"
  ssh_username  = "ubuntu"
  tags = {
    Env  = "Dev"
    Name = "${local.app_name}"
  }
}

build {
  sources = ["source.amazon-ebs.jenkins-agent"]

  provisioner "ansible" {
    playbook_file = "jenkins-agent.yml"
  }

}
