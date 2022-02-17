resource "aws_iam_policy" "privesc-sageMakerCreateTrainingJobPassRole-policy" {
  name        = "privesc-sageMakerCreateTrainingJobPassRole-policy"
  path        = "/"
  description = "Allows privesc via sagemakerCreateTraining"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sagemaker:CreateTrainingJob",
          "iam:PassRole"
        ]
        Resource = "*"
      },
    ]
  })
  tags = {
    yor_trace = "730ae751-4b95-4b31-b64c-0dc23ba1025c"
  }
}



resource "aws_iam_role" "privesc-sageMakerCreateTrainingJobPassRole-role" {
  name = "privesc-sageMakerCreateTrainingJobPassRole-role"
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
    yor_trace = "ae82f796-c8dc-45fc-9141-17ec7e77c5a6"
  }
}


resource "aws_iam_user" "privesc-sageMakerCreateTrainingJobPassRole-user" {
  name = "privesc-sageMakerCreateTrainingJobPassRole-user"
  path = "/"
  tags = {
    yor_trace = "832b5170-87b3-49f9-a67f-32267d585106"
  }
}

resource "aws_iam_access_key" "privesc-sageMakerCreateTrainingJobPassRole-user" {
  user = aws_iam_user.privesc-sageMakerCreateTrainingJobPassRole-user.name
}



resource "aws_iam_user_policy_attachment" "privesc-sageMakerCreateTrainingJobPassRole-user-attach-policy" {
  user       = aws_iam_user.privesc-sageMakerCreateTrainingJobPassRole-user.name
  policy_arn = aws_iam_policy.privesc-sageMakerCreateTrainingJobPassRole-policy.arn
}


resource "aws_iam_role_policy_attachment" "privesc-sageMakerCreateTrainingJobPassRole-role-attach-policy" {
  role       = aws_iam_role.privesc-sageMakerCreateTrainingJobPassRole-role.name
  policy_arn = aws_iam_policy.privesc-sageMakerCreateTrainingJobPassRole-policy.arn

}

