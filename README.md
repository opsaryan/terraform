# Terraform learning

Lessons in order (top to bottom). Each folder is its own Terraform root (run `terraform init` inside it).
Region everywhere: `ap-south-1`.

| Order | Folder | Topic | Key ideas |
| --- | --- | --- | --- |
| 1 | [first-ec2-instance](first-ec2-instance) | First resource | provider, `data "aws_ami"`, `aws_instance`, local state |
| 2 | [remote-state-backend](remote-state-backend) | Remote state | S3 bucket + DynamoDB lock table, `backend "s3"` |
| 3 | [three-tier-app-single-file](three-tier-app-single-file) | Full app, one file | VPC, subnets, IGW, route table, security groups, EC2 x2, ALB, Route 53, variables |
| 4 | [modules-and-dry](modules-and-dry) | Modules + DRY | `bootstrap/` for state, `modules/{network,compute,database}`, outputs between modules |
| 5 | [multi-environment](multi-environment) | Environments + tests | `global/`, `staging/`, `production/` share `modules/`, RDS, Terratest — see its README |

## Layout pattern per lesson

```
topic/
├── bootstrap/ or global/   created once (state bucket, lock table, hosted zone)
├── modules/                reusable pieces (no backend, no provider)
├── <root or env dirs>/     main.tf, vars.tf, outputs.tf — where you run terraform
└── README.md               notes for the lesson
```

## Order to apply

Anything with a `bootstrap/` or `global/` folder: apply that first, then the root/env folders.
