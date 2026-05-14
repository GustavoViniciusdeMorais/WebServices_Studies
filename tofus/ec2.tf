data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  # Canonical's official AWS owner ID
  owners = ["099720109477"]
}

resource "aws_instance" "web" {
  # This now references the dynamically found AMI
  ami           = data.aws_ami.ubuntu.id
  instance_type = "m7i-flex.large"
  key_name      = "my-ec2-key"  # This must match the name in the AWS console

  tags = {
    Name = "PHP"
  }
}