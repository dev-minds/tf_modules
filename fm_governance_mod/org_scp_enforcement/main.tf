# https://github.com/trussworks/terraform-aws-org-scp/blob/master/main.tf
# 

#
# Deny member account leaving AWS Organizations
#

data "aws_iam_policy_document" "deny_leaving_orgs" {
  statement {
    effect    = "Deny"
    actions   = ["organizations:LeaveOrganization"]
    resources = ["*"]
  }
}

resource "aws_organizations_policy" "deny_leaving_orgs" {
  name        = var.default-scp-rule-name
  description = "Deny the ability for an AWS account or Organizational Unit from leaving the AWS Organization"
  content     = data.aws_iam_policy_document.deny_leaving_orgs.json
}

resource "aws_organizations_policy_attachment" "deny_leaving_orgs" {
  count     = length(var.associate-acct-ids)
  policy_id = aws_organizations_policy.deny_leaving_orgs.id
  target_id = element(var.associate-acct-ids.*, count.index)
}

#
# Org Tagging Policy | Owner Tag
# 
resource "aws_organizations_policy" "org_tagging_policy" {
  name        = var.restrict-tagpolicy-name
  type        = "TAG_POLICY"
  description = "Tagging Policy defined"
  content = jsonencode({"tags":{"Owner":{"tag_key":{"@@assign":"Owner","@@operators_allowed_for_child_policies":["@@none"]},"tag_value":{"@@assign":["devops","infrastructure","product lifecycle","datalake","data","account team","security"]},"enforced_for":{"@@assign":["apigateway:apikeys","apigateway:domainnames","apigateway:restapis","apigateway:stages","appmesh:*","athena:*","acm:*","cloudfront:*","cloudtrail:*","cloudwatch:*","events:*","codebuild:*","codecommit:*","codepipeline:*","cognito-identity:*","cognito-idp:*","comprehend:*","config:*","directconnect:*","dms:*","dynamodb:*","ec2:capacity-reservation","ec2:client-vpn-endpoint","ec2:customer-gateway","ec2:dhcp-options","ec2:elastic-ip","ec2:fleet","ec2:fpga-image","ec2:host-reservation","ec2:image","ec2:instance","ec2:internet-gateway","ec2:launch-template","ec2:natgateway","ec2:network-acl","ec2:network-interface","ec2:reserved-instances","ec2:route-table","ec2:security-group","ec2:snapshot","ec2:spot-instance-request","ec2:subnet","ec2:traffic-mirror-filter","ec2:traffic-mirror-target","ec2:traffic-mirror-session","ec2:volume","ec2:vpc","ec2:vpc-endpoint","ec2:vpc-endpoint-service","ec2:vpc-peering-connection","ec2:vpn-connection","ec2:vpn-gateway","elasticfilesystem:*","elasticbeanstalk:application","elasticbeanstalk:applicationversion","elasticbeanstalk:configurationtemplate","elasticbeanstalk:platform","ecs:task-set","ecs:cluster","ecs:service","elasticache:cluster","elasticloadbalancing:*","firehose:*","fsx:*","iotanalytics:*","iotevents:*","kinesisanalytics:*","kms:*","lambda:*","rds:cluster-pg","rds:es","rds:og","rds:pg","rds:ri","rds:secgrp","rds:subgrp","redshift:*","ram:*","resource-groups:*","route53:hostedzone","route53resolver:*","s3:bucket"]}}}})
}

resource "aws_organizations_policy_attachment" "org_tag_policy_attachment" {
  count     = length(var.associate-acct-ids)
  policy_id = aws_organizations_policy.org_tagging_policy.id
  target_id = element(var.associate-acct-ids.*, count.index)
}


# 
# SCP enforcement policy 
#

resource "aws_organizations_policy" "org_scp_enforce_policy" {
  name        = var.enforce-scp-rule-name
  description = "This SCP enforces tags for instances"

  content = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "DenyRunInstanceWithNoOwnerTag",
            "Effect": "Deny",
            "Action": "ec2:RunInstances",
            "Resource": [
                "arn:aws:ec2:*:*:instance/*",
                "arn:aws:ec2:*:*:volume/*"
            ],
            "Condition": {
                "Null": {
                    "aws:RequestTag/Owner": "true"
                }
            }
        },
        {
            "Sid": "DenyCreateVolumeWithNoOwnerTag",
            "Effect": "Deny",
            "Action": "ec2:CreateVolume",
            "Resource": [
                "arn:aws:ec2:*:*:volume/*"
            ],
            "Condition": {
                "Null": {
                    "aws:RequestTag/Owner": "true"
                }
            }
        },
        {
            "Sid": "DenyCreatSecurityGroupWithNoOwnerTag",
            "Effect": "Deny",
            "Action": [
                "ec2:CreateSecurityGroup"
            ],
            "Resource": [
                "arn:aws:ec2:*:*:security-group/*"
            ],
            "Condition": {
                "Null": {
                    "aws:RequestTag/Owner": "true"
                }
            }
        },
        {
            "Sid": "DenyRemovingOwnerTag",
            "Effect": "Deny",
            "Action": [
                "ec2:DeleteTags"
            ],
            "Resource": [
                "arn:aws:ec2:*:*:instance/*",
                "arn:aws:ec2:*:*:volume/*",
                "arn:aws:ec2:*:*:security-group/*"
            ],
            "Condition": {
                "Null": {
                    "aws:RequestTag/Owner": "false"
                }
            }
        },
        {
            "Sid": "Statement3",
            "Effect": "Deny",
            "Action": [
                "secretsmanager:UntagResource"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
POLICY
}

resource "aws_organizations_policy_attachment" "tag_attach" {
  count     = length(var.associate-acct-ids)
  policy_id = aws_organizations_policy.org_scp_enforce_policy.id
  target_id = element(var.associate-acct-ids.*, count.index)
}


#
# =============================================================
# 


# data "aws_iam_policy_document" "restrict_regions" {
#   statement {
#     effect = "Deny"

#     # These actions do not operate in a specific region, or only run in
#     # a single region, so we don't want to try restricting them by region.
#     not_actions = [
#       "iam:*",
#       "organizations:*",
#       "route53:*",
#       "budgets:*",
#       "waf:*",
#       "cloudfront:*",
#       "globalaccelerator:*",
#       "importexport:*",
#       "support:*",
#       "sts:*"
#     ]

#     resources = ["*"]
#     sid       = "LimitRegionsSCP"

#     condition {
#       test     = "StringNotEquals"
#       variable = "aws:RequestedRegion"
#       values   = var.allowed_regions
#     }
#   }
# }

# resource "aws_organizations_policy" "restrict_regions" {
#   name        = "restrict-regions"
#   description = "Restrict regions for deployable resources"
#   content     = data.aws_iam_policy_document.restrict_regions.json
# }

# resource "aws_organizations_policy_attachment" "restrict_regions" {
#   count = length(var.restrict_regions_target_ids)

#   policy_id = aws_organizations_policy.restrict_regions.id
#   target_id = element(var.restrict_regions_target_ids.*, count.index)
# }

#
# Deny creating IAM users or access keys
#

# data "aws_iam_policy_document" "deny_creating_iam_users" {
#   statement {
#     effect = "Deny"
#     actions = [
#       "iam:CreateUser",
#       "iam:CreateAccessKey"
#     ]
#     resources = ["*"]
#   }
# }

# resource "aws_organizations_policy" "deny_creating_iam_users" {
#   name        = "deny-creating-iam-users"
#   description = "Deny the ability to create IAM users or Access Keys"
#   content     = data.aws_iam_policy_document.deny_creating_iam_users.json
# }

# resource "aws_organizations_policy_attachment" "deny_creating_iam_users" {
#   count = length(var.deny_creating_iam_users_target_ids)

#   policy_id = aws_organizations_policy.deny_creating_iam_users.id
#   target_id = element(var.deny_creating_iam_users_target_ids.*, count.index)
# }

#
# Deny deleting KMS Keys
#

# data "aws_iam_policy_document" "deny_deleting_kms_keys" {
#   statement {
#     effect = "Deny"
#     actions = [
#       "kms:ScheduleKeyDeletion",
#       "kms:Delete*"
#     ]
#     resources = ["*"]
#   }
# }

# resource "aws_organizations_policy" "deny_deleting_kms_keys" {
#   name        = "deny-deleting-kms-keys"
#   description = "Deny deleting KMS keys"
#   content     = data.aws_iam_policy_document.deny_deleting_kms_keys.json
# }

# resource "aws_organizations_policy_attachment" "deny_deleting_kms_keys" {
#   count = length(var.deny_deleting_kms_keys_target_ids)

#   policy_id = aws_organizations_policy.deny_deleting_kms_keys.id
#   target_id = element(var.deny_deleting_kms_keys_target_ids.*, count.index)
# }

#
# Deny deleting Route53 Hosted Zones
#

# data "aws_iam_policy_document" "deny_deleting_route53_zones" {
#   statement {
#     effect = "Deny"
#     actions = [
#       "route53:DeleteHostedZone"
#     ]
#     resources = ["*"]
#   }
# }

# resource "aws_organizations_policy" "deny_deleting_route53_zones" {
#   name        = "deny-deleting-route53-zones"
#   description = "Deny deleting Route53 Hosted Zones"
#   content     = data.aws_iam_policy_document.deny_deleting_route53_zones.json
# }

# resource "aws_organizations_policy_attachment" "deny_deleting_route53_zones" {
#   count = length(var.deny_deleting_route53_zones_target_ids)

#   policy_id = aws_organizations_policy.deny_deleting_route53_zones.id
#   target_id = element(var.deny_deleting_route53_zones_target_ids.*, count.index)
# }

#
# Deny all access
#

# data "aws_iam_policy_document" "deny_all_access" {
#   statement {
#     effect    = "Deny"
#     actions   = ["*"]
#     resources = ["*"]
#   }
# }

# resource "aws_organizations_policy" "deny_all_access" {
#   name        = "deny-all-access"
#   description = "Deny all access"
#   content     = data.aws_iam_policy_document.deny_all_access.json
# }

# resource "aws_organizations_policy_attachment" "deny_all_access" {
#   count = length(var.deny_all_access_target_ids)

#   policy_id = aws_organizations_policy.deny_all_access.id
#   target_id = element(var.deny_all_access_target_ids.*, count.index)
# }

#
# Require S3 encryption
#

# https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_example-scps.html#example-require-encryption
# data "aws_iam_policy_document" "require_s3_encryption" {
#   statement {
#     effect    = "Deny"
#     actions   = ["s3:PutObject"]
#     resources = ["*"]
#     condition {
#       test     = "StringNotEquals"
#       variable = "s3:x-amz-server-side-encryption"
#       values   = ["AES256"]
#     }
#   }
#   statement {
#     effect    = "Deny"
#     actions   = ["s3:PutObject"]
#     resources = ["*"]
#     condition {
#       test     = "Null"
#       variable = "s3:x-amz-server-side-encryption"
#       values   = [true]
#     }
#   }
# }

# resource "aws_organizations_policy" "require_s3_encryption" {
#   name        = "require-s3-encryption"
#   description = "Require that all Amazon S3 buckets use AES256 encryption"
#   content     = data.aws_iam_policy_document.require_s3_encryption.json
# }

# resource "aws_organizations_policy_attachment" "require_s3_encryption" {
#   count = length(var.require_s3_encryption_target_ids)

#   policy_id = aws_organizations_policy.require_s3_encryption.id
#   target_id = element(var.require_s3_encryption_target_ids.*, count.index)
# }

#
# Deny deleting VPC Flow logs, cloudwatch log groups, and cloudwatch log streams
#

# data "aws_iam_policy_document" "deny_deleting_cloudwatch_logs" {
#   statement {
#     effect = "Deny"
#     actions = [
#       "ec2:DeleteFlowLogs",
#       "logs:DeleteLogGroup",
#       "logs:DeleteLogStream"
#     ]
#     resources = ["*"]
#   }
# }

# resource "aws_organizations_policy" "deny_deleting_cloudwatch_logs" {
#   name        = "deny-deleting-cloudwatch-logs"
#   description = "Deny deleting Cloudwatch log groups, log streams, and VPC flow logs"
#   content     = data.aws_iam_policy_document.deny_deleting_cloudwatch_logs.json
# }

# resource "aws_organizations_policy_attachment" "deny_deleting_cloudwatch_logs" {
#   count = length(var.deny_deleting_cloudwatch_logs_target_ids)

#   policy_id = aws_organizations_policy.deny_deleting_cloudwatch_logs.id
#   target_id = element(var.deny_deleting_cloudwatch_logs_target_ids.*, count.index)
# }

#
# Protect S3 Buckets
#

# data "aws_iam_policy_document" "protect_s3_buckets" {
#   statement {
#     effect = "Deny"
#     actions = [
#       "s3:DeleteBucket",
#       "s3:DeleteObject",
#       "s3:DeleteObjectVersion",
#     ]
#     resources = var.protect_s3_bucket_resources
#   }
# }

# resource "aws_organizations_policy" "protect_s3_buckets" {
#   count       = length(var.protect_s3_bucket_target_ids)
#   name        = "protect-s3-buckets"
#   description = "Protect S3 buckets form bucket and object deletion"
#   content     = data.aws_iam_policy_document.protect_s3_buckets.json
# }

# resource "aws_organizations_policy_attachment" "protect_s3_buckets" {
#   count = length(var.protect_s3_bucket_target_ids)

#   policy_id = aws_organizations_policy.protect_s3_buckets[0].id
#   target_id = element(var.protect_s3_bucket_target_ids.*, count.index)
# }

#
# Protect IAM roles
#

# data "aws_iam_policy_document" "protect_iam_roles" {
#   count = length(var.protect_iam_role_resources) != 0 ? 1 : 0

#   statement {
#     effect = "Deny"
#     actions = [
#       "iam:AttachRolePolicy",
#       "iam:DeleteRole",
#       "iam:DeleteRolePermissionsBoundary",
#       "iam:DeleteRolePolicy",
#       "iam:DetachRolePolicy",
#       "iam:PutRolePermissionsBoundary",
#       "iam:PutRolePolicy",
#       "iam:UpdateAssumeRolePolicy",
#       "iam:UpdateRole",
#       "iam:UpdateRoleDescription"
#     ]
#     resources = var.protect_iam_role_resources
#   }
# }

# resource "aws_organizations_policy" "protect_iam_roles" {
#   count = length(var.protect_iam_role_resources) != 0 ? 1 : 0

#   name        = "protect-iam-roles"
#   description = "Protect IAM roles from modification or deletion"
#   content     = data.aws_iam_policy_document.protect_iam_roles[0].json
# }

# resource "aws_organizations_policy_attachment" "protect_iam_roles" {
#   count = var.protect_iam_role_resources != [""] ? length(var.protect_iam_role_target_ids) : 0

#   policy_id = aws_organizations_policy.protect_iam_roles[0].id
#   target_id = element(var.protect_iam_role_target_ids.*, count.index)
# }

#
# Restrict Regional Operations
#


# Fetch Master Account Org ID 

#
# Deny root account
#

# data "aws_iam_policy_document" "deny_root_account" {
#   statement {
#     actions   = ["*"]
#     resources = ["*"]
#     effect    = "Deny"
#     condition {
#       test     = "StringLike"
#       variable = "aws:PrincipalArn"
#       values   = ["arn:aws:iam::*:root"]
#     }
#   }
# }

# resource "aws_organizations_policy" "deny_root_account" {
#   name        = "deny-root-account"
#   description = "Deny the root user from taking any action"
#   content     = data.aws_iam_policy_document.deny_root_account.json
# }

# resource "aws_organizations_policy_attachment" "deny_root_account" {
#   count = length(var.deny_root_account_target_ids)

#   policy_id = aws_organizations_policy.deny_root_account.id
#   target_id = element(var.deny_root_account_target_ids.*, count.index)
# }
