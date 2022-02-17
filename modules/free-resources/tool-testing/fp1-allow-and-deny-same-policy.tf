# Does the tool evaluate deny's first before allows like AWS does? Many tools ignore or incorrectly handle DENY actions

resource "aws_iam_policy" "fp1-allow-and-deny" {
  name        = "fp1-allow-and-deny"
  path        = "/"
  description = "Allows iam:* but also denys iam:* which means no access"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow",
        Action   = "iam:*",
        Resource = "*"
      },
      {
        Effect   = "Deny",
        Action   = "iam:*",
        Resource = "*"
      }
    ]
  })
  tags = {
    yor_trace = "94a70e79-4903-4bd9-ad36-65103fdfbf42"
  }
}

resource "aws_iam_role" "fp1-allow-and-deny-role" {
  name = "fp1-allow-and-deny-role"
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
    yor_trace = "922cb111-2355-404b-ac2b-4190db7a75fc"
  }
}

resource "aws_iam_user" "fp1-allow-and-deny-user" {
  name = "fp1-allow-and-deny-user"
  path = "/"
  tags = {
    yor_trace = "e5f45d53-1c11-47d0-a365-f07ad16e23e5"
  }
}

resource "aws_iam_access_key" "fp1-allow-and-deny-user" {
  user = aws_iam_user.fp1-allow-and-deny-user.name
}

resource "aws_iam_user_policy_attachment" "fp1-allow-and-deny-user-attach-policy" {
  user       = aws_iam_user.fp1-allow-and-deny-user.name
  policy_arn = aws_iam_policy.fp1-allow-and-deny.arn
}


resource "aws_iam_role_policy_attachment" "fp1-allow-and-deny-role-attach-policy" {
  role       = aws_iam_role.fp1-allow-and-deny-role.name
  policy_arn = aws_iam_policy.fp1-allow-and-deny.arn

}

