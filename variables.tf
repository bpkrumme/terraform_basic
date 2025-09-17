variable "ec2_region" {
  description = "Region for our EC2 instances."
  type        = string
  default     = "us-east-2"
}
variable "instance_name" {
  description = "Value of the EC2 instance's Name tag."
  type        = string
  default     = "tfserver"
}

variable "instance_type" {
  description = "The EC2 instance's type."
  type        = string
  default     = "t3.micro"
}

variable "instance_key" {
  description = "The key used for the EC2 instance."
  type        = string
  default     = "awskeypair"
}

variable "number_of_instances" {
  description = "The number of EC2 instances."
  type        = number
  default     = 4
}

variable "instance_domain_name" {
  description = "The domain name for EC2 instances."
  type        = string
  default     = "braddoestech.com"
}

variable "instance_environment" {
  description = "The environment for grouping EC2 instances."
  type        = string
  default     = "Development"
}
