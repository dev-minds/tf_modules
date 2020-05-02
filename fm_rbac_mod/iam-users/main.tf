resource "aws_iam_user" "dm_user_res" {
  count         = "${length(var.all_users)}"
  name          = "${element(var.all_users, count.index)}"
  path          = "/"
  force_destroy = "true"
}

// resource "aws_iam_user_login_profile" "dm_login_prof" {
//   count                   = "${length(var.all_users)}"
//   user                    = "${element(aws_iam_user.dm_user_res.*.name, count.index)}"
//   pgp_key                 = ""
//   password_length         = "5"
//   password_reset_required = true
// }

resource "aws_iam_access_key" "dm_user_access_res" {
  count = "${length(var.all_users)}"
  user  = "${element(aws_iam_user.dm_user_res.*.name, count.index)}"
}


# ======================================================================= #
variable "all_users" {
  description = "Specify usernames"
  type        = list
  default = []
}

# ======================================================================== # 
output "user_map_to_access_id" {
  value = "${zipmap(aws_iam_user.dm_user_res.*.name, aws_iam_access_key.dm_user_access_res.*.id)}"
}

output "user_map_to_secret" {
  value = "${zipmap(aws_iam_user.dm_user_res.*.name, aws_iam_access_key.dm_user_access_res.*.secret)}"
}