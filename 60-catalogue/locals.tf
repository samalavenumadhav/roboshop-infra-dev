locals {
    ami_id = data.aws_ami.joindevops.value
    catalogue_sg_id = data.aws_ssm_parameter.backend_alb_sg_id.value
    private_subnet_ids = data.aws_ssm_parameter.private_subnet_ids.value

    common_tags = {
        Project = var.project
        Environment = var.environment
        Terraform = "true"
    }
}