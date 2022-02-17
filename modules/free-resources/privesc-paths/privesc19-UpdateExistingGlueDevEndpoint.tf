resource "aws_iam_policy" "privesc19-UpdateExistingGlueDevEndpoint" {
  name        = "privesc19-UpdateExistingGlueDevEndpoint"
  path        = "/"
  description = "Allows privesc via glue:UpdateDevEndpoint and glue:GetDevEndpoint"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "glue:UpdateDevEndpoint",
          "glue:GetDevEndpoint"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
  tags = {
    yor_trace = "8e930aef-f9c3-43e0-a557-d283482058a4"
  }
}

resource "aws_iam_role" "privesc19-UpdateExistingGlueDevEndpoint-role" {
  name = "privesc19-UpdateExistingGlueDevEndpoint-role"
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
    yor_trace = "276ca4a1-7dd9-4f99-ba2f-e833833ca712"
  }
}

resource "aws_iam_user" "privesc19-UpdateExistingGlueDevEndpoint-user" {
  name = "privesc19-UpdateExistingGlueDevEndpoint-user"
  path = "/"
  tags = {
    yor_trace = "00380139-5c95-4fa4-ac67-23d479710159"
  }
}

resource "aws_iam_access_key" "privesc19-UpdateExistingGlueDevEndpoint-user" {
  user = aws_iam_user.privesc19-UpdateExistingGlueDevEndpoint-user.name
}


resource "aws_iam_user_policy_attachment" "privesc19-UpdateExistingGlueDevEndpoint-user-attach-policy" {
  user       = aws_iam_user.privesc19-UpdateExistingGlueDevEndpoint-user.name
  policy_arn = aws_iam_policy.privesc19-UpdateExistingGlueDevEndpoint.arn
}

resource "aws_iam_role_policy_attachment" "privesc19-UpdateExistingGlueDevEndpoint-role-attach-policy" {
  role       = aws_iam_role.privesc19-UpdateExistingGlueDevEndpoint-role.name
  policy_arn = aws_iam_policy.privesc19-UpdateExistingGlueDevEndpoint.arn
}
