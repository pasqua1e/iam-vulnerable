resource "aws_iam_policy" "privesc8-AttachGroupPolicy" {
  name        = "privesc8-AttachGroupPolicy"
  path        = "/"
  description = "Allows privesc via iam:AttachGroupPolicy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "iam:AttachGroupPolicy"
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
  tags = {
    yor_trace = "b30d97b3-9bd4-4fc1-81ec-7e3ac114f311"
  }
}

resource "aws_iam_role" "privesc8-AttachGroupPolicy-role" {
  name = "privesc8-AttachGroupPolicy-role"
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
    yor_trace = "0180305c-70d8-4bb2-ad83-21d7bfe47d8c"
  }
}

resource "aws_iam_user" "privesc8-AttachGroupPolicy-user" {
  name = "privesc8-AttachGroupPolicy-user"
  path = "/"
  tags = {
    yor_trace = "f3af19e4-9600-4e51-b16a-7a694e2190f7"
  }
}

resource "aws_iam_access_key" "privesc8-AttachGroupPolicy-user" {
  user = aws_iam_user.privesc8-AttachGroupPolicy-user.name
}


resource "aws_iam_user_policy_attachment" "privesc8-AttachGroupPolicy-user-attach-policy" {
  user       = aws_iam_user.privesc8-AttachGroupPolicy-user.name
  policy_arn = aws_iam_policy.privesc8-AttachGroupPolicy.arn
}

resource "aws_iam_role_policy_attachment" "privesc8-AttachGroupPolicy-role-attach-policy" {
  role       = aws_iam_role.privesc8-AttachGroupPolicy-role.name
  policy_arn = aws_iam_policy.privesc8-AttachGroupPolicy.arn
}


resource "aws_iam_group" "privesc8-AttachGroupPolicy-group" {
  name = "privesc8-AttachGroupPolicy-group"
  path = "/"
}

resource "aws_iam_group_membership" "privesc8-AttachGroupPolicy-group-membership" {
  name = "privesc8-AttachGroupPolicy-group-membership"

  users = [
    aws_iam_user.privesc8-AttachGroupPolicy-user.name
  ]

  group = aws_iam_group.privesc8-AttachGroupPolicy-group.name
}