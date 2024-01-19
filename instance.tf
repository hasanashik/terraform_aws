resource "aws_key_pair" "my-key" {
  key_name   = "my-key"
  public_key = file("my-key.pub")
}

resource "aws_instance" "zaman-inst" {
  ami                    = var.AMIS[var.REGION]
  instance_type          = "t2.micro"
  availability_zone      = var.ZONE1
  key_name               = aws_key_pair.my-key.key_name
  vpc_security_group_ids = ["sg-0b4aae9ce10f66ef9"]
  tags = {
    Name    = "zaman-Instance"
    Project = "zaman"
  }

  provisioner "file" {
    source      = "web.sh"
    destination = "/tmp/web.sh"
  }

  provisioner "remote-exec" {

    inline = [
      "chmod +x /tmp/web.sh",
      "sudo /tmp/web.sh"
    ]
  }

  connection {
    user        = var.USER
    private_key = file("my-key")
    host        = self.public_ip
  }
}
