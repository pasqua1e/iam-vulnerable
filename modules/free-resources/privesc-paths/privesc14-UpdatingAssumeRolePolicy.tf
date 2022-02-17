resource "aws_iam_policy" "privesc14-UpdatingAssumeRolePolicy" {
  name        = "privesc14-UpdatingAssumeRolePolicy"
  path        = "/"
  description = "Allows privesc via iam:UpdateAssumeRolePolicy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [

      {
        Action = [
          "iam:UpdateAssumeRolePolicy",
          "sts:AssumeRole"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
  tags = {
    yor_trace = "e4b7632a-5a7b-4a02-9c59-c691f69395aa"
  }
}

resource "aws_iam_role" "privesc14-UpdatingAssumeRolePolicy-role" {
  name = "privesc14-UpdatingAssumeRolePolicy-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          AWS = var.aws_assume_role_arn
        }
      },
    ]
  })
  tags = {
    yor_trace = "79e64757-e9ff-4996-9c0c-788cfc1b5dae"
  }
}

resource "aws_iam_user" "privesc14-UpdatingAssumeRolePolicy-user" {
  name = "privesc14-UpdatingAssumeRolePolicy-user"
  path = "/"
  tags = {
    yor_trace = "9d652637-03ad-4c64-8a54-24a8fa98b0f2"
  }
}

resource "aws_iam_access_key" "privesc14-UpdatingAssumeRolePolicy-user" {
  user = aws_iam_user.privesc14-UpdatingAssumeRolePolicy-user.name
}


resource "aws_iam_user_policy_attachment" "privesc14-UpdatingAssumeRolePolicy-user-attach-policy" {
  user       = aws_iam_user.privesc14-UpdatingAssumeRolePolicy-user.name
  policy_arn = aws_iam_policy.privesc14-UpdatingAssumeRolePolicy.arn
}

resource "aws_iam_role_policy_attachment" "privesc14-UpdatingAssumeRolePolicy-role-attach-policy" {
  role       = aws_iam_role.privesc14-UpdatingAssumeRolePolicy-role.name
  policy_arn = aws_iam_policy.privesc14-UpdatingAssumeRolePolicy.arn
}