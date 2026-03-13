# Launch the bastion EC2 instance
resource "aws_instance" "bastion" {
  ami                         = local.ami_id
  instance_type               = "t3.micro"
  subnet_id                   = local.public_subnet_id
  vpc_security_group_ids      = [local.bastion_sg_id]


  tags = merge(
    {
        Name = "${var.project}-${var.environment}-bastion"
    },
    local.common_tags
  )
}

resource "aws_iam_role" "bastion" {
  name = "RoboshopDevBastion"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
     tags = merge(
    {
        Name = "RoboshopDevBastion"
    },
    local.common_tags
  )
}
#Permissions
/* resource "aws_iam_role_policy_attachment" "bastion" {
  role       = 
  policy_arn = aws_iam_policy.policy.arn
} */