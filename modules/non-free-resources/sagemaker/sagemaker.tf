resource "aws_sagemaker_notebook_instance" "privesc-sagemakerNotebook" {
  name          = "privesc-sagemakerNotebook"
  role_arn      = aws_iam_role.privesc-sagemaker-role.arn
  instance_type = "ml.t2.medium"

  tags = {
    Name      = "foo"
    yor_trace = "170a2074-ac73-4bce-ac7e-6acb5a3f0bf8"
  }
}


resource "aws_iam_role" "privesc-sagemaker-role" {
  name               = "privesc-sagemaker-role"
  assume_role_policy = data.aws_iam_policy_document.example.json
  tags = {
    yor_trace = "33146636-7320-47d6-805c-9c4f775a23d6"
  }
}

data "aws_iam_policy_document" "example" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["sagemaker.amazonaws.com"]
    }
  }
}


resource "aws_iam_policy" "privesc-high-priv-sagemaker-policy" {
  name        = "privesc-high-priv-sagemaker-policy2"
  path        = "/"
  description = "High priv policy used by sagemaker"
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
    yor_trace = "c533f46d-cb07-4e7e-86b0-90be29706652"
  }
}


resource "aws_iam_role_policy_attachment" "example-AWSSagemakerServiceRole" {
  policy_arn = aws_iam_policy.privesc-high-priv-sagemaker-policy.arn
  role       = aws_iam_role.privesc-sagemaker-role.name
}