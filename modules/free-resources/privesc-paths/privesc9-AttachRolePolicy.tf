resource "aws_iam_policy" "privesc9-AttachRolePolicy" {
  name        = "privesc9-AttachRolePolicy"
  path        = "/"
  description = "Allows privesc via iam:AttachRolePolicy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "iam:AttachRolePolicy"
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
  tags = {
    yor_trace = "53a6405d-2bea-4b3a-8937-ee1c31ab9eb0"
  }
}

resource "aws_iam_role" "privesc9-AttachRolePolicy-role" {
  name = "privesc9-AttachRolePolicy-role"
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
    yor_trace = "867ed403-74bc-44c4-bce0-f99869d16084"
  }
}

resource "aws_iam_user" "privesc9-AttachRolePolicy-user" {
  name = "privesc9-AttachRolePolicy-user"
  path = "/"
  tags = {
    yor_trace = "54fa0f8d-e898-48e1-ad85-780166b5ede0"
  }
}

resource "aws_iam_access_key" "privesc9-AttachRolePolicy-user" {
  user = aws_iam_user.privesc9-AttachRolePolicy-user.name
}


resource "aws_iam_user_policy_attachment" "privesc9-AttachRolePolicy-user-attach-policy" {
  user       = aws_iam_user.privesc9-AttachRolePolicy-user.name
  policy_arn = aws_iam_policy.privesc9-AttachRolePolicy.arn
}

resource "aws_iam_role_policy_attachment" "privesc9-AttachRolePolicy-role-attach-policy" {
  role       = aws_iam_role.privesc9-AttachRolePolicy-role.name
  policy_arn = aws_iam_policy.privesc9-AttachRolePolicy.arn
}