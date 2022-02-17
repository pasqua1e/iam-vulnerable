resource "aws_iam_policy" "privesc-ssmStartSession-policy" {
  name        = "privesc-ssmStartSession-policy"
  path        = "/"
  description = "Allows privesc via targeted ssm"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstances",
          "ssm:StartSession",
          "ssm:DescribeSessions",
          "ssm:GetConnectionStatus",
          "ssm:DescribeInstanceProperties",
          "ssm:TerminateSession",
          "ssm:ResumeSession"
        ]
        Resource = "*"
      },
    ]
  })
  tags = {
    yor_trace = "66285658-5c35-465d-98e5-b8f1a622c37a"
  }
}



resource "aws_iam_role" "privesc-ssmStartSession-role" {
  name = "privesc-ssmStartSession-role"
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
    yor_trace = "6e4aef52-1670-44c1-be50-ab4eaf81c249"
  }
}


resource "aws_iam_user" "privesc-ssmStartSession-user" {
  name = "privesc-ssmStartSession-user"
  path = "/"
  tags = {
    yor_trace = "3e092b09-6f11-45fa-a20e-7ec97803d0d8"
  }
}

resource "aws_iam_access_key" "privesc-ssmStartSession-user" {
  user = aws_iam_user.privesc-ssmStartSession-user.name
}



resource "aws_iam_user_policy_attachment" "privesc-ssmStartSession-user-attach-policy" {
  user       = aws_iam_user.privesc-ssmStartSession-user.name
  policy_arn = aws_iam_policy.privesc-ssmStartSession-policy.arn
}


resource "aws_iam_role_policy_attachment" "privesc-ssmStartSession-role-attach-policy" {
  role       = aws_iam_role.privesc-ssmStartSession-role.name
  policy_arn = aws_iam_policy.privesc-ssmStartSession-policy.arn

}

