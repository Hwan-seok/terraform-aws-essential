# Terraform

## Only once

1. install terraform
2. install awscli
3.

```bash
$ aws configure # configure your profile
$ cd live/${wanna deploy} # caution for dependencies
$ vi main.tf # change provider profile as created before
$ terraform init
```

## Initialize

```bash
$ terraform apply
```

## Destroy

```bash
$ terraform destroy
```

### Dependencies

- Must deploy LTR

  > VPC > LB > APP
  > VPC > RDS
