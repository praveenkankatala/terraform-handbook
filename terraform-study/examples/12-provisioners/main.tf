# Example 12 - Provisioners & connections.
# Provisioners take EXTRA action after a resource is created (or destroyed):
# run a script locally, or copy/run something on the remote machine.
# Use them as a LAST RESORT - prefer native resources or user_data.

terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.60"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "t2.micro"
  key_name      = "my-keypair" # must exist in the account

  # local-exec: run a command on the machine running Terraform.
  provisioner "local-exec" {
    command = "echo ${self.public_ip} >> ips.txt"
  }

  # How to reach the instance for file/remote-exec provisioners.
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file("~/.ssh/id_rsa")
  }

  # file: copy a local file to the remote host.
  provisioner "file" {
    source      = "app.conf"
    destination = "/tmp/app.conf"
  }

  # remote-exec: run commands ON the instance after creation.
  provisioner "remote-exec" {
    inline = [
      "sudo yum install -y nginx",
      "sudo systemctl enable --now nginx",
    ]
  }

  # A destroy-time provisioner runs when the resource is destroyed.
  provisioner "local-exec" {
    when    = destroy
    command = "echo 'instance destroyed' >> lifecycle.log"
  }
}

# null_resource + triggers: run provisioners without a "real" resource.
resource "null_resource" "post_deploy" {
  triggers = {
    instance_id = aws_instance.web.id # re-run when the instance changes
  }

  provisioner "local-exec" {
    command = "echo 'deployed ${aws_instance.web.id}'"
  }
}
