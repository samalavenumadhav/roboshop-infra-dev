
locals {
  ami_id           = data.aws_ami.openvpn
  openvpn_sg_id    = data.aws_ssm_parameter.openvpn_sg_id.value
  public_subnet_id = split(",", data.aws_ssm_parameter.private_subnet_ids.value)[0]
  common_tags = {
    Project     = var.project
    Environment = var.environment
    Terraform   = "true"
  }
}
