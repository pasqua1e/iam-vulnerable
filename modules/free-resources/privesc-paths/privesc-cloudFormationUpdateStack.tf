resource "aws_iam_policy" "privesc-CloudFormationUpdateStack" {
  name        = "privesc-CloudFormationUpdateStack"
  path        = "/"
  description = "Allows privesc via cloudformation:UpdateStack"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "cloudformation:UpdateStack",
          "cloudformation:DescribeStacks"
        ],
        "Resource" : "*"
      }
    ]
  })
  tags = {
    yor_trace = "e9db480c-16ec-4a2c-8796-ff258f1ecb3c"
  }
}

resource "aws_iam_role" "privesc-CloudFormationUpdateStack-role" {
  name = "privesc-CloudFormationUpdateStack-role"
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
    yor_trace = "cc368933-057f-4a6e-b54b-a2b3238853db"
  }
}

resource "aws_iam_user" "privesc-CloudFormationUpdateStack-user" {
  name = "privesc-CloudFormationUpdateStack-user"
  path = "/"
  tags = {
    yor_trace = "a82589dd-a0ad-4a89-9f7a-88cbf7dca363"
  }
}

resource "aws_iam_access_key" "privesc-CloudFormationUpdateStack-user" {
  user = aws_iam_user.privesc-CloudFormationUpdateStack-user.name
}


resource "aws_iam_user_policy_attachment" "privesc-CloudFormationUpdateStack-user-attach-policy" {
  user       = aws_iam_user.privesc-CloudFormationUpdateStack-user.name
  policy_arn = aws_iam_policy.privesc-CloudFormationUpdateStack.arn
}

resource "aws_iam_role_policy_attachment" "privesc-CloudFormationUpdateStack-role-attach-policy" {
  role       = aws_iam_role.privesc-CloudFormationUpdateStack-role.name
  policy_arn = aws_iam_policy.privesc-CloudFormationUpdateStack.arn
}
