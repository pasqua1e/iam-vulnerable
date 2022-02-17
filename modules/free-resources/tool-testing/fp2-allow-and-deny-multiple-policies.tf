resource "aws_iam_policy" "fp2-allow-all" {
  name        = "fp2-allow-all"
  path        = "/"
  description = "Allows everything"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow",
        Action   = "*",
        Resource = "*"
      },
    ]
  })
  tags = {
    yor_trace = "6f3dc55d-9ef2-4ea5-b0ec-17e62bb5a3eb"
  }
}

resource "aws_iam_policy" "deny-all" {
  name        = "deny-all"
  path        = "/"
  description = "Denies everything"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Deny",
        Action   = "*",
        Resource = "*"
      },
    ]
  })
  tags = {
    yor_trace = "57b410f2-0d89-495a-8f98-ec57437ea723"
  }
}




resource "aws_iam_role" "fp2-allow-and-deny-multiple-policies-role" {
  name = "fp2-allow-and-deny-multiple-policies-role"
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
    yor_trace = "a48827f3-0009-4053-91f4-fdfb1d344b8a"
  }
}

resource "aws_iam_user" "fp2-allow-and-deny-multiple-policies-user" {
  name = "fp2-allow-and-deny-multiple-policies-user"
  path = "/"
  tags = {
    yor_trace = "d3bf1b5c-bd96-410c-8613-9ce2c74b74b6"
  }
}

resource "aws_iam_access_key" "fp2-allow-and-deny-multiple-policies-user" {
  user = aws_iam_user.fp2-allow-and-deny-multiple-policies-user.name
}



resource "aws_iam_user_policy_attachment" "fp2-allow-and-deny-attach-allow-to-user" {
  user       = aws_iam_user.fp2-allow-and-deny-multiple-policies-user.name
  policy_arn = aws_iam_policy.fp2-allow-all.arn
}

resource "aws_iam_user_policy_attachment" "fp2-allow-and-deny-attach-deny-to-user" {
  user       = aws_iam_user.fp2-allow-and-deny-multiple-policies-user.name
  policy_arn = aws_iam_policy.deny-all.arn
}

resource "aws_iam_role_policy_attachment" "fp2-allow-and-deny-attach-allow-to-role" {
  role       = aws_iam_role.fp2-allow-and-deny-multiple-policies-role.name
  policy_arn = aws_iam_policy.fp2-allow-all.arn

}

resource "aws_iam_role_policy_attachment" "fp2-allow-and-deny-attach-deny-to-roler" {
  role       = aws_iam_role.fp2-allow-and-deny-multiple-policies-role.name
  policy_arn = aws_iam_policy.deny-all.arn

}
