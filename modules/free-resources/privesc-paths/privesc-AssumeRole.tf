resource "aws_iam_policy" "privesc-AssumeRole-high-priv-policy" {
  name        = "privesc-AssumeRole-high-priv-policy"
  path        = "/"
  description = "Allows privesc via targeted sts:AssumeRole"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "*"
        Resource = "*"
      },
    ]
  })
  tags = {
    yor_trace = "0d0c407c-ddf7-49b7-9cc9-77d51b85e88d"
  }
}

resource "aws_iam_role" "privesc-AssumeRole-starting-role" {
  name = "privesc-AssumeRole-starting-role"
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
    yor_trace = "51b16ed5-4bb9-4b55-a53a-fd2e1c1d55d1"
  }
}

resource "aws_iam_role" "privesc-AssumeRole-intermediate-role" {
  name = "privesc-AssumeRole-intermediate-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          AWS = aws_iam_role.privesc-AssumeRole-starting-role.arn
        }
      },
    ]
  })
  tags = {
    yor_trace = "45298b82-9433-4b1d-99e8-f026bd4de0e2"
  }
}


resource "aws_iam_role" "privesc-AssumeRole-ending-role" {
  name = "privesc-AssumeRole-ending-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          AWS = aws_iam_role.privesc-AssumeRole-intermediate-role.arn
        }
      },
    ]
  })
  tags = {
    yor_trace = "6719d71c-c42b-48f5-83ee-e6446c7ec9af"
  }
}



resource "aws_iam_user" "privesc-AssumeRole-start-user" {
  name = "privesc-AssumeRole-start-user"
  path = "/"
  tags = {
    yor_trace = "bda1c70a-a39b-4d22-892f-aaa6f7ff3289"
  }
}
resource "aws_iam_access_key" "privesc-AssumeRole-start-user" {
  user = aws_iam_user.privesc-AssumeRole-start-user.name
}
resource "aws_iam_role_policy_attachment" "privesc-AssumeRole-high-priv-policy-role-attach-policy" {
  role       = aws_iam_role.privesc-AssumeRole-ending-role.name
  policy_arn = aws_iam_policy.privesc-AssumeRole-high-priv-policy.arn

}  