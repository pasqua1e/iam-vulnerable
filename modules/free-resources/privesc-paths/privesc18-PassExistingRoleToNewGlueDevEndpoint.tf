resource "aws_iam_policy" "privesc18-PassExistingRoleToNewGlueDevEndpoint" {
  name        = "privesc18-PassExistingRoleToNewGlueDevEndpoint"
  path        = "/"
  description = "Allows privesc via glue:CreateDevEndpoint, glue:GetDevEndpoint and iam:passrole"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "glue:CreateDevEndpoint",
          "glue:GetDevEndpoint",
          "iam:PassRole"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
  tags = {
    yor_trace = "45f8b1f6-11fd-4076-8d1b-eca506908ea7"
  }
}

resource "aws_iam_role" "privesc18-PassExistingRoleToNewGlueDevEndpoint-role" {
  name = "privesc18-PassExistingRoleToNewGlueDevEndpoint-role"
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
    yor_trace = "ae53d264-c801-4fb9-9715-8d40e5cdb34d"
  }
}

resource "aws_iam_user" "privesc18-PassExistingRoleToNewGlueDevEndpoint-user" {
  name = "privesc18-PassExistingRoleToNewGlueDevEndpoint-user"
  path = "/"
  tags = {
    yor_trace = "adec0147-97f1-4b57-8c6c-2d3297a8993e"
  }
}

resource "aws_iam_access_key" "privesc18-PassExistingRoleToNewGlueDevEndpoint-user" {
  user = aws_iam_user.privesc18-PassExistingRoleToNewGlueDevEndpoint-user.name
}


resource "aws_iam_user_policy_attachment" "privesc18-PassExistingRoleToNewGlueDevEndpoint-user-attach-policy" {
  user       = aws_iam_user.privesc18-PassExistingRoleToNewGlueDevEndpoint-user.name
  policy_arn = aws_iam_policy.privesc18-PassExistingRoleToNewGlueDevEndpoint.arn
}

resource "aws_iam_role_policy_attachment" "privesc18-PassExistingRoleToNewGlueDevEndpoint-role-attach-policy" {
  role       = aws_iam_role.privesc18-PassExistingRoleToNewGlueDevEndpoint-role.name
  policy_arn = aws_iam_policy.privesc18-PassExistingRoleToNewGlueDevEndpoint.arn
}
