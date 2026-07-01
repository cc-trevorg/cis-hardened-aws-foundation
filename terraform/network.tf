data "aws_vpc" "default" {

  default = true

}

# A default SG with no ingress/egress blocks = denies all traffic

resource "aws_default_security_group" "default" {

  vpc_id = data.aws_vpc.default.id

  # intentionally no ingress/egress rules

}

