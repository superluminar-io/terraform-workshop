data "aws_iam_policy" "admin" {
  name = "AdministratorAccess"
}

resource "aws_iam_user" "ci" {
  name = "CI"
}

resource "aws_iam_user_policy_attachment" "ci" {
  user       = aws_iam_user.ci.name
  policy_arn = data.aws_iam_policy.admin.arn
}
