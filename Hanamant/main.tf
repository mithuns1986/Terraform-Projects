provider "aws" {
   region     = "us-west-1"
}
resource "aws_instance" "ec2_terraform" {
   ami           = "ami-02541b8af977f6cdd"
   instance_type = var.instance_type
   tags = {
           Name = "Terraform_EC2"
   }
}

variable "instance_type" {
   description = "Instance type t2.micro"
   type        = string
   default     = "t2.micro"
}
