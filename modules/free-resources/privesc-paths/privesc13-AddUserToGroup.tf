resource "aws_iam_policy" "privesc13-AddUserToGroup" {
  name        = "privesc13-AddUserToGroup"
  path        = "/"
  description = "Allows privesc via iam:AddUserToGroup"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "iam:AddUserToGroup"
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
  tags = {
    yor_trace = "147c40fa-f640-4f1c-bd59-0917bbe1d54c"
  }
}

resource "aws_iam_role" "privesc13-AddUserToGroup-role" {
  name = "privesc13-AddUserToGroup-role"
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
    yor_trace = "014144b3-957d-40fc-8526-e6f15d735a40"
  }
}

resource "aws_iam_user" "privesc13-AddUserToGroup-user" {
  name = "privesc13-AddUserToGroup-user"
  path = "/"
  tags = {
    yor_trace = "93259fc6-b295-4d52-ad9c-b09425eed8c2"
  }
}

resource "aws_iam_access_key" "privesc13-AddUserToGroup-user" {
  user = aws_iam_user.privesc13-AddUserToGroup-user.name
}


resource "aws_iam_user_policy_attachment" "privesc13-AddUserToGroup-user-attach-policy" {
  user       = aws_iam_user.privesc13-AddUserToGroup-user.name
  policy_arn = aws_iam_policy.privesc13-AddUserToGroup.arn
}

resource "aws_iam_role_policy_attachment" "privesc13-AddUserToGroup-role-attach-policy" {
  role       = aws_iam_role.privesc13-AddUserToGroup-role.name
  policy_arn = aws_iam_policy.privesc13-AddUserToGroup.arn
}


