resource "aws_iam_policy" "privesc-sre-admin-policy" {
  name        = "privesc-sre-admin-policy"
  path        = "/"
  description = "High priv policy Role used by SREs"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "iam:*",
          "ec2:*",
          "s3:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
  tags = {
    yor_trace = "99022182-e781-4b88-9b45-31f4b8bfec9a"
  }
}


resource "aws_iam_role" "privesc-sre-role" {
  name = "privesc-sre-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          AWS = aws_iam_user.privesc-sre-user.arn
        }
      },
    ]
  })
  managed_policy_arns = [aws_iam_policy.privesc-sre-admin-policy.arn]
  tags = {
    yor_trace = "ac143fb8-bb80-416c-bf50-f6895a449b98"
  }
}

resource "aws_iam_user" "privesc-sre-user" {
  name = "privesc-sre-user"
  path = "/"
  tags = {
    yor_trace = "b8e1a40f-565f-4b44-ab34-62743bde5a90"
  }
}

resource "aws_iam_access_key" "privesc-sre-user" {
  user = aws_iam_user.privesc-sre-user.name
}

resource "aws_iam_group" "privesc-sre-group" {
  name = "privesc-sre-group"
  path = "/"
}

resource "aws_iam_group_membership" "privesc-sre-group-membership" {
  name = "privesc-sre-group-membership"

  users = [
    aws_iam_user.privesc-sre-user.name
  ]
  group = aws_iam_group.privesc-sre-group.name
}


resource "aws_iam_group_policy_attachment" "privesc-sre-group-attach-policy" {
  group      = aws_iam_group.privesc-sre-group.name
  policy_arn = aws_iam_policy.privesc-sre-admin-policy.arn
}


resource "aws_iam_role_policy_attachment" "privesc-sre-role-attach-policy" {
  role       = aws_iam_role.privesc-sre-role.name
  policy_arn = aws_iam_policy.privesc-sre-admin-policy.arn
}
