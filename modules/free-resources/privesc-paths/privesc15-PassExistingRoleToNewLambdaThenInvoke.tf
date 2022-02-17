resource "aws_iam_policy" "privesc15-PassExistingRoleToNewLambdaThenInvoke" {
  name        = "privesc15-PassExistingRoleToNewLambdaThenInvoke"
  path        = "/"
  description = "Allows privesc via lambda:createfunction, invokefunction and iam:passrole"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "lambda:CreateFunction",
          "iam:PassRole",
          "lambda:InvokeFunction"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
  tags = {
    yor_trace = "4a7d3061-af35-47c2-a9d7-104e1d2bb8b7"
  }
}

resource "aws_iam_role" "privesc15-PassExistingRoleToNewLambdaThenInvoke-role" {
  name = "privesc15-PassExistingRoleToNewLambdaThenInvoke-role"
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
    yor_trace = "29f9e63c-b4f9-4d60-abf1-c5d80c719e97"
  }
}

resource "aws_iam_user" "privesc15-PassExistingRoleToNewLambdaThenInvoke-user" {
  name = "privesc15-PassExistingRoleToNewLambdaThenInvoke-user"
  path = "/"
  tags = {
    yor_trace = "615fcc73-a6c4-48d6-8fd1-9718f92ecab8"
  }
}

resource "aws_iam_access_key" "privesc15-PassExistingRoleToNewLambdaThenInvoke-user" {
  user = aws_iam_user.privesc15-PassExistingRoleToNewLambdaThenInvoke-user.name
}


resource "aws_iam_user_policy_attachment" "privesc15-PassExistingRoleToNewLambdaThenInvoke-user-attach-policy" {
  user       = aws_iam_user.privesc15-PassExistingRoleToNewLambdaThenInvoke-user.name
  policy_arn = aws_iam_policy.privesc15-PassExistingRoleToNewLambdaThenInvoke.arn
}

resource "aws_iam_role_policy_attachment" "privesc15-PassExistingRoleToNewLambdaThenInvoke-role-attach-policy" {
  role       = aws_iam_role.privesc15-PassExistingRoleToNewLambdaThenInvoke-role.name
  policy_arn = aws_iam_policy.privesc15-PassExistingRoleToNewLambdaThenInvoke.arn
}