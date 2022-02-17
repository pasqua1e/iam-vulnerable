resource "aws_iam_policy" "privesc11-PutGroupPolicy" {
  name        = "privesc11-PutGroupPolicy"
  path        = "/"
  description = "Allows privesc via iam:PutGroupPolicy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "iam:PutGroupPolicy"
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
  tags = {
    yor_trace = "d309907f-5b7c-440d-981d-38f8cefc9021"
  }
}

resource "aws_iam_role" "privesc11-PutGroupPolicy-role" {
  name = "privesc11-PutGroupPolicy-role"
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
    yor_trace = "f4a2243c-f40b-4d54-a73a-5a2bb01795e7"
  }
}

resource "aws_iam_user" "privesc11-PutGroupPolicy-user" {
  name = "privesc11-PutGroupPolicy-user"
  path = "/"
  tags = {
    yor_trace = "2bd132c6-f0a3-4cff-8f2d-e8a0c5eb6351"
  }
}

resource "aws_iam_access_key" "privesc11-PutGroupPolicy-user" {
  user = aws_iam_user.privesc11-PutGroupPolicy-user.name
}


resource "aws_iam_user_policy_attachment" "privesc11-PutGroupPolicy-user-attach-policy" {
  user       = aws_iam_user.privesc11-PutGroupPolicy-user.name
  policy_arn = aws_iam_policy.privesc11-PutGroupPolicy.arn
}

resource "aws_iam_role_policy_attachment" "privesc11-PutGroupPolicy-role-attach-policy" {
  role       = aws_iam_role.privesc11-PutGroupPolicy-role.name
  policy_arn = aws_iam_policy.privesc11-PutGroupPolicy.arn
}

resource "aws_iam_group" "privesc11-PutGroupPolicy-group" {
  name = "privesc11-PutGroupPolicy-group"
  path = "/"
}

resource "aws_iam_group_membership" "privesc11-PutGroupPolicy-group-membership" {
  name = "privesc11-PutGroupPolicy-group-membership"

  users = [
    aws_iam_user.privesc11-PutGroupPolicy-user.name
  ]

  group = aws_iam_group.privesc11-PutGroupPolicy-group.name
}