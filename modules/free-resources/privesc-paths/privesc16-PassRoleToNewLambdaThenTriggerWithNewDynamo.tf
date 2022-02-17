resource "aws_iam_policy" "privesc16-PassRoleToNewLambdaThenTriggerWithNewDynamo" {
  name        = "privesc16-PassRoleToNewLambdaThenTriggerWithNewDynamo"
  path        = "/"
  description = "Allows privesc via lambda:createfunction, CreateEventSourceMapping and iam:passrole"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "lambda:CreateFunction",
          "iam:PassRole",
          "lambda:CreateEventSourceMapping"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
  tags = {
    yor_trace = "a883b5d6-ca56-4a73-a1e4-39b003ee1e1b"
  }
}

resource "aws_iam_role" "privesc16-PassRoleToNewLambdaThenTriggerWithNewDynamo-role" {
  name = "privesc16-PassRoleToNewLambdaThenTriggerWithNewDynamo-role"
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
    yor_trace = "3a056e68-692d-47f5-b3d8-58d404ab686e"
  }
}

resource "aws_iam_user" "privesc16-PassRoleToNewLambdaThenTriggerWithNewDynamo-user" {
  name = "privesc16-PassRoleToNewLambdaThenTriggerWithNewDynamo-user"
  path = "/"
  tags = {
    yor_trace = "8c21264c-e9dd-4511-a37d-52e0c292519a"
  }
}

resource "aws_iam_access_key" "privesc16-PassRoleToNewLambdaThenTriggerWithNewDynamo-user" {
  user = aws_iam_user.privesc16-PassRoleToNewLambdaThenTriggerWithNewDynamo-user.name
}


resource "aws_iam_user_policy_attachment" "privesc16-PassRoleToNewLambdaThenTriggerWithNewDynamo-user-attach-policy" {
  user       = aws_iam_user.privesc16-PassRoleToNewLambdaThenTriggerWithNewDynamo-user.name
  policy_arn = aws_iam_policy.privesc16-PassRoleToNewLambdaThenTriggerWithNewDynamo.arn
}

resource "aws_iam_role_policy_attachment" "privesc16-PassRoleToNewLambdaThenTriggerWithNewDynamo-role-attach-policy" {
  role       = aws_iam_role.privesc16-PassRoleToNewLambdaThenTriggerWithNewDynamo-role.name
  policy_arn = aws_iam_policy.privesc16-PassRoleToNewLambdaThenTriggerWithNewDynamo.arn
}