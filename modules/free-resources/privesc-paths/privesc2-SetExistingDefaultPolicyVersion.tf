#Note: This one is not exploitable if the only thing in your account is the IAM-Vulnerable stuff. 
#      For this to be exploitable, you would need to make a revision of this policy and give all access, 
#      and then set it back to this policy. After that, you can demonstrate exploitation. (I could not figure
#      out how to make multiple versions of a policy with terraform)

resource "aws_iam_policy" "privesc2-SetExistingDefaultPolicyVersion" {
  name        = "privesc2-SetExistingDefaultPolicyVersion"
  path        = "/"
  description = "Allows privesc via iam:SetDefaultPolicyVersion."

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "iam:SetDefaultPolicyVersion"
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
  tags = {
    yor_trace = "0c839a81-0525-4f9a-86d1-4cd7a3c7da01"
  }
}

resource "aws_iam_role" "privesc2-SetExistingDefaultPolicyVersion-role" {
  name = "privesc2-SetExistingDefaultPolicyVersion-role"
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
    yor_trace = "6d741ee2-f80f-4700-9d5b-9f7772128ce0"
  }
}

resource "aws_iam_user" "privesc2-SetExistingDefaultPolicyVersion-user" {
  name = "privesc2-SetExistingDefaultPolicyVersion-user"
  path = "/"
  tags = {
    yor_trace = "a9ef656d-1cb1-4419-8eff-cd92b15b3a8f"
  }
}

resource "aws_iam_access_key" "privesc2-SetExistingDefaultPolicyVersion-user" {
  user = aws_iam_user.privesc2-SetExistingDefaultPolicyVersion-user.name
}


resource "aws_iam_user_policy_attachment" "privesc2-SetExistingDefaultPolicyVersion-user-attach-policy" {
  user       = aws_iam_user.privesc2-SetExistingDefaultPolicyVersion-user.name
  policy_arn = aws_iam_policy.privesc2-SetExistingDefaultPolicyVersion.arn
}

resource "aws_iam_role_policy_attachment" "privesc2-SetExistingDefaultPolicyVersion-role-attach-policy" {
  role       = aws_iam_role.privesc2-SetExistingDefaultPolicyVersion-role.name
  policy_arn = aws_iam_policy.privesc2-SetExistingDefaultPolicyVersion.arn

}