// Data sources
data "aws_region" "current" {}

// Create a security group policy and setup rules for Threat Manager appliance
resource "aws_security_group" "tmc_sg" {
  name = "Alert Logic Threat Manager Security Group"

  tags {
    Name = "Alert Logic Threat Manager Security Group"
  }

  vpc_id = "${var.vpc_id}"

  // pwaf ingress rules (uncomment to apply rules)
  /*
      ingress	{
        protocol = "tcp"
        cidr_blocks = ["204.110.218.96/27"]
        from_port = 4849
        to_port = 4849
      }
      ingress	{
        protocol = "tcp"
        cidr_blocks = ["204.110.219.96/27"]
        from_port = 4849
        to_port = 4849
      }
      ingress	{
        protocol = "tcp"
        cidr_blocks = ["208.71.209.32/27"]
        from_port = 4849
        to_port = 4849
      }
      */
  ingress {
    protocol    = "tcp"
    cidr_blocks = ["${var.monitoring_cidr}"]
    from_port   = 7777
    to_port     = 7777
  }

  ingress {
    protocol    = "tcp"
    cidr_blocks = ["${var.monitoring_cidr}"]
    from_port   = 443
    to_port     = 443
  }

  ingress {
    protocol    = "tcp"
    cidr_blocks = ["${var.claim_cidr}"]
    from_port   = 80
    to_port     = 80
  }

  egress {
    protocol    = "tcp"
    cidr_blocks = ["204.110.218.96/27"]
    from_port   = 443
    to_port     = 443
  }

  egress {
    protocol    = "tcp"
    cidr_blocks = ["204.110.219.96/27"]
    from_port   = 443
    to_port     = 443
  }

  egress {
    protocol    = "tcp"
    cidr_blocks = ["208.71.209.32/27"]
    from_port   = 443
    to_port     = 443
  }

  egress {
    protocol    = "tcp"
    cidr_blocks = ["185.54.124.0/24"]
    from_port   = 443
    to_port     = 443
  }

  egress {
    protocol    = "tcp"
    cidr_blocks = ["204.110.218.96/27"]
    from_port   = 4138
    to_port     = 4138
  }

  egress {
    protocol    = "tcp"
    cidr_blocks = ["204.110.219.96/27"]
    from_port   = 4138
    to_port     = 4138
  }

  egress {
    protocol    = "tcp"
    cidr_blocks = ["208.71.209.32/27"]
    from_port   = 4138
    to_port     = 4138
  }

  egress {
    protocol    = "tcp"
    cidr_blocks = ["185.54.124.0/24"]
    from_port   = 4138
    to_port     = 4138
  }

  egress {
    protocol    = "udp"
    cidr_blocks = ["8.8.8.8/32"]
    from_port   = 53
    to_port     = 53
  }

  egress {
    protocol    = "udp"
    cidr_blocks = ["8.8.4.4/32"]
    from_port   = 53
    to_port     = 53
  }

  egress {
    protocol    = "tcp"
    cidr_blocks = ["8.8.8.8/32"]
    from_port   = 53
    to_port     = 53
  }

  egress {
    protocol    = "tcp"
    cidr_blocks = ["8.8.4.4/32"]
    from_port   = 53
    to_port     = 53
  }
}

// Launch a Threat Manager instance from a shared AMI
resource "aws_instance" "tmc" {
  depends_on             = ["aws_security_group.tmc_sg"]
  count                  = "${var.alertlogic_enabled == 1 ? 1 : 0}"
  ami                    = "${lookup(var.aws_amis, data.aws_region.current.name)}"
  instance_type          = "${var.instance_type}"
  subnet_id              = "${var.subnet_id}"
  vpc_security_group_ids = ["${aws_security_group.tmc_sg.id}"]

  tags {
    Name = "${var.tag_name}"
    env  = "${var.tag_env}"
  }
}

// Allocate a new Elastic IP to be associated with the new Threat Manager instance
resource "aws_eip" "tmc" {
  depends_on = ["aws_instance.tmc"]
  count      = "${var.alertlogic_enabled == 1 ? var.create_eip : 0}"
  instance   = "${aws_instance.tmc.id}"
  vpc        = true
}
