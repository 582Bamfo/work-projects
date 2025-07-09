terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.98.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}


resource "aws_iam_user" "this" {
  name = "lee"
}

resource "aws_iam_user_login_profile" "this" {
  user                    = aws_iam_user.this.name
  pgp_key                 = "keybase:dbamfo"
  password_reset_required = true
  password_length         = 8
}

data "aws_iam_policy_document" "change_password" {
  statement {
    effect = "Allow"
    actions = [
      "iam:ChangePassword",
#      "iam:GetAccountPasswordPolicy"
    ]
#    resources = ["*"]
     resources = ["arn:aws:iam::*:user/$${aws:username}"]
  }
  
  
  statement {
    
      effect = "Deny"
      not_actions =[
        "iam:ResyncMFADevice",
        "iam:ListUsers",
        "iam:ListMFADevices",
        "iam:EnableMFADevice",
        "iam:ChangePassword"
      ]
      resources = ["*"]
    }
  
}



resource "aws_iam_policy" "change_password" {
  name        = "ChangeOwnPassword"
  description = "Allow users to change their own password"
  policy      = data.aws_iam_policy_document.change_password.json
}

# resource "aws_iam_user_policy_attachment" "change_password" {
#   user       = aws_iam_user.this.name
#   policy_arn = aws_iam_policy.change_password.arn
# }

output "lee_password" {
  value     = aws_iam_user_login_profile.this.encrypted_password 
  sensitive = true
}


resource "aws_iam_group" "developers" {
  name = "developers"
  path = "/users/"
}


resource "aws_iam_group_membership" "team" {
  name = "testing-group-membership"

  users = [
    aws_iam_user.this.name,
  
  ]

  group = aws_iam_group.developers.name
}

resource "aws_iam_group_policy_attachment" "test-attach" {
  group      = aws_iam_group.developers.name
  policy_arn = aws_iam_policy.change_password.arn
}
