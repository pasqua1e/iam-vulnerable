resource "aws_iam_policy" "privesc1-CreateNewPolicyVersion" {
  name        = "privesc1-CreateNewPolicyVersion"
  path        = "/"
  description = "Allows privesc via iam:CreatePolicyVersion"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "iam:CreatePolicyVersion"
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
  tags = {
    yor_trace = "4a78bdc9-8beb-4d1c-a5c9-572bb59596dc"
  }
}

resource "aws_iam_role" "privesc1-CreateNewPolicyVersion-role" {
  name = "privesc1-CreateNewPolicyVersion-role"
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
    yor_trace = "c01b4ff4-4b65-4751-aafc-5f1bffc8feda"
  }
}


resource "aws_iam_user" "privesc1-CreateNewPolicyVersion-user" {
  name = "privesc1-CreateNewPolicyVersion-user"
  path = "/"
  tags = {
    yor_trace = "ed4a89ce-1e21-4f3e-b0b8-c87644cbe107"
  }
}

resource "aws_iam_access_key" "privesc1-CreateNewPolicyVersion-user" {
  user = aws_iam_user.privesc1-CreateNewPolicyVersion-user.name
}


resource "aws_iam_user_policy_attachment" "privesc1-CreateNewPolicyVersion-user-attach-policy" {
  user       = aws_iam_user.privesc1-CreateNewPolicyVersion-user.name
  policy_arn = aws_iam_policy.privesc1-CreateNewPolicyVersion.arn
}

resource "aws_iam_role_policy_attachment" "privesc1-CreateNewPolicyVersion-role-attach-policy" {
  role       = aws_iam_role.privesc1-CreateNewPolicyVersion-role.name
  policy_arn = aws_iam_policy.privesc1-CreateNewPolicyVersion.arn

}  