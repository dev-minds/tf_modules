
data "template_file" "user_data" {
  template = file("${path.module}/user_data.sh")

  vars = {
    aws_region              = var.aws_region
    bucket_name             = var.bucket_name
    extra_user_data_content = var.extra_user_data_content
    allow_ssh_commands      = var.allow_ssh_commands
  }
}

