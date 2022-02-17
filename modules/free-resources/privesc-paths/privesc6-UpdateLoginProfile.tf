resource "aws_iam_policy" "privesc6-UpdateLoginProfile" {
  name        = "privesc6-UpdateLoginProfile"
  path        = "/"
  description = "Allows privesc via iam:UpdateLoginProfile"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "iam:UpdateLoginProfile"
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
  tags = {
    yor_trace = "41d6e13a-2c73-4053-8440-16c7b415ba14"
  }
}

resource "aws_iam_role" "privesc6-UpdateLoginProfile-role" {
  name = "privesc6-UpdateLoginProfile-role"
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
    yor_trace = "dacd7569-2042-45fc-a52f-909a3022b474"
  }
}

resource "aws_iam_user" "privesc6-UpdateLoginProfile-user" {
  name = "privesc6-UpdateLoginProfile-user"
  path = "/"
  tags = {
    yor_trace = "708b5563-f866-4410-8944-43a30753feb4"
  }
}

resource "aws_iam_access_key" "privesc6-UpdateLoginProfile-user" {
  user = aws_iam_user.privesc6-UpdateLoginProfile-user.name
}


resource "aws_iam_user_policy_attachment" "privesc6-UpdateLoginProfile-user-attach-policy" {
  user       = aws_iam_user.privesc6-UpdateLoginProfile-user.name
  policy_arn = aws_iam_policy.privesc6-UpdateLoginProfile.arn
}

resource "aws_iam_role_policy_attachment" "privesc6-UpdateLoginProfile-role-attach-policy" {
  role       = aws_iam_role.privesc6-UpdateLoginProfile-role.name
  policy_arn = aws_iam_policy.privesc6-UpdateLoginProfile.arn
}
