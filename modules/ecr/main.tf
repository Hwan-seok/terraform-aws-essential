resource "aws_ecr_repository" "ecr" {
  name                 = "repo"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "delete_except_3" {
  repository = aws_ecr_repository.ecr.name

  policy = <<EOF
    {
        "rules": [
            {
                "rulePriority": 1,
                "description": "Keep last 3 images",
                "selection": {
                    "tagStatus": "tagged",
                    "tagPrefixList": ["dev-"],
                    "countType": "imageCountMoreThan",
                    "countNumber": 3
                },
                "action": {
                    "type": "expire"
                }
            },
            {
                "rulePriority": 2,
                "description": "Keep last 3 images",
                "selection": {
                    "tagStatus": "tagged",
                    "tagPrefixList": ["stage-"],
                    "countType": "imageCountMoreThan",
                    "countNumber": 3
                },
                "action": {
                    "type": "expire"
                }
            },
            {
                "rulePriority": 3,
                "description": "Keep last 3 images",
                "selection": {
                    "tagStatus": "tagged",
                    "tagPrefixList": ["real-"],
                    "countType": "imageCountMoreThan",
                    "countNumber": 3
                },
                "action": {
                    "type": "expire"
                }
            }
        ]
    }
    EOF
}
