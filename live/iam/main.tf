provider "aws" {
  region  = "ap-northeast-2"
  profile = "terraform"
}

resource "aws_iam_instance_profile" "ec2_ecr_readonly" {
  name = "ec2_ecr_readonly"
  role = aws_iam_role.ecr_readonly.name
}

resource "aws_iam_role" "ecr_readonly" {
  name = "AmazonEC2ContainerRegistryReadOnlyRole"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
    {
        "Action": "sts:AssumeRole",
        "Principal": {
        "Service": "ec2.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
    }
    ]
}
EOF

  tags = {
    Name = "ecr_readonly"
  }
}

resource "aws_iam_role_policy_attachment" "for_ecr_readonly" {
  role       = aws_iam_role.ecr_readonly.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}


# resource "aws_iam_policy" "policy" {
#   name        = "test-policy"
#   description = "A test policy"


#   policy = <<EOF
# {
# 	"Version": "2012-10-17",
# 	"Statement": [{
# 		"Effect": "Allow",
# 		"Action": [
# 			"ecr:GetAuthorizationToken",
# 			"ecr:BatchCheckLayerAvailability",
# 			"ecr:GetDownloadUrlForLayer",
# 			"ecr:GetRepositoryPolicy",
# 			"ecr:DescribeRepositories",
# 			"ecr:ListImages",
# 			"ecr:DescribeImages",
# 			"ecr:BatchGetImage"
# 		],
# 		"Resource": "*"
# 	}]
# }
# EOF
# }
