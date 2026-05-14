data "aws_iam_policy_document" "ec2_ami_access" {
  statement {
    effect = "Allow"
    actions = [
      "ec2:DescribeImages"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_user_policy" "admin_ami_access" {
  name   = "EC2DescribeImages"
  user   = "Admin"
  policy = data.aws_iam_policy_document.ec2_ami_access.json
}