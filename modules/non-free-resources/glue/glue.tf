resource "aws_glue_dev_endpoint" "privesc-glue-devendpoint" {
  name     = "privesc-glue-devendpoint"
  role_arn = aws_iam_role.privesc-glue-devendpoint-role.arn
  tags = {
    yor_trace = "f4508a68-5599-41a9-8e37-97de5e94ea41"
  }
}

resource "aws_iam_role" "privesc-glue-devendpoint-role" {
  name               = "privesc-glue-devendpoint-role"
  assume_role_policy = data.aws_iam_policy_document.example.json
  tags = {
    yor_trace = "8a7ca8bd-2ba0-48e3-9f78-da38dd18b982"
  }
}

data "aws_iam_policy_document" "example" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["glue.amazonaws.com"]
    }
  }
}


resource "aws_iam_policy" "privesc-high-priv-glue-policy" {
  name        = "privesc-high-priv-glue-policy2"
  path        = "/"
  description = "High priv policy used by glue"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "*"
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
  tags = {
    yor_trace = "7c23cc5e-1eee-42f0-b0da-b2ac57d5f6d6"
  }
}


resource "aws_iam_role_policy_attachment" "example-AWSGlueServiceRole" {
  policy_arn = aws_iam_policy.privesc-high-priv-glue-policy.arn
  role       = aws_iam_role.privesc-glue-devendpoint-role.name
}