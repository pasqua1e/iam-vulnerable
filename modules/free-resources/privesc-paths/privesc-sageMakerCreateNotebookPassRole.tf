resource "aws_iam_policy" "privesc-sageMakerCreateNotebookPassRole-policy" {
  name        = "privesc-sageMakerCreateNotebookPassRole-policy"
  path        = "/"
  description = "Allows privesc via sagemakerCreateNotebook"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sagemaker:CreateNotebookInstance",
          "sagemaker:CreatePresignedNotebookInstanceUrl",
          "sagemaker:ListNotebookInstances",
          "sagemaker:DescribeNotebookInstance",
          "sagemaker:StopNotebookInstance",
          "sagemaker:DeleteNotebookInstance",
          "iam:PassRole",
          "iam:ListRoles"
        ]
        Resource = "*"
      },
    ]
  })
  tags = {
    yor_trace = "e25e6bf1-9fa6-47fe-97ec-6d1e8e0b959a"
  }
}



resource "aws_iam_role" "privesc-sageMakerCreateNotebookPassRole-role" {
  name = "privesc-sageMakerCreateNotebookPassRole-role"
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
    yor_trace = "cac96792-257a-49bf-9bfa-cb1d2a6a7e34"
  }
}


resource "aws_iam_user" "privesc-sageMakerCreateNotebookPassRole-user" {
  name = "privesc-sageMakerCreateNotebookPassRole-user"
  path = "/"
  tags = {
    yor_trace = "67b645ca-65cf-48e4-abc3-840fcac1dc06"
  }
}

resource "aws_iam_access_key" "privesc-sageMakerCreateNotebookPassRole-user" {
  user = aws_iam_user.privesc-sageMakerCreateNotebookPassRole-user.name
}



resource "aws_iam_user_policy_attachment" "privesc-sageMakerCreateNotebookPassRole-user-attach-policy" {
  user       = aws_iam_user.privesc-sageMakerCreateNotebookPassRole-user.name
  policy_arn = aws_iam_policy.privesc-sageMakerCreateNotebookPassRole-policy.arn
}


resource "aws_iam_role_policy_attachment" "privesc-sageMakerCreateNotebookPassRole-role-attach-policy" {
  role       = aws_iam_role.privesc-sageMakerCreateNotebookPassRole-role.name
  policy_arn = aws_iam_policy.privesc-sageMakerCreateNotebookPassRole-policy.arn

}

