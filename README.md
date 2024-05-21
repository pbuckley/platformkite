# platformkite

An example repository to demonstrate running Buildkite as a platform

## Local dependencies

This demo repository was used and tested on MacOS Sonoma 14.4 with the following tools installed and configured...

- Apple Xcode Command Line Tools
- Homebrew (optional)
- AWS CLI
- Terraform CLI

## Prerequisites

- x

## Instructions

1. If not already set up, "manually" deploy s3 bucket and dynamodb table to use terraform remote state

```
cd terraform/remote-state
terraform init
terraform plan
terraform apply
```

2. Set the following environment variables

```bash
# temporary

export BUILDKITE_ORGANIZATION_SLUG
export BUILDKITE_API_TOKEN=12345
export AWS_PROFILE=default

# permanent (bash)
echo 'export BUILDKITE_API_TOKEN=12345' >> ~/.bash_profile
echo 'export BUILDKITE_ORGANIZATION_SLUG=12345' >> ~/.bash_profile

# permanent (zsh)
echo 'export BUILDKITE_API_TOKEN=12345' >> ~/.zshenv
echo 'export BUILDKITE_ORGANIZATION_SLUG=my-org' >> ~/.zshenv
```

## To Do

<!-- - s3 backend for state -->
<!-- - dynamodb lock table -->

- could be a cluster per file, and the file includes config, queues, tokens

- https://guide.buildkite.net/engineering/architecture/aws/tagging/index.html
- create vpc, subnets, s3 bucket, etc.
- upload secret
- instructions
- get buildkite user as data and use in aws tags
- on pipeline creation choose from random colours and emojis

- CODEOWNER rules
- terralith (terraform monolith)

## Now

- Fix duplicate default queues being allowed

## Next

- Packer build custom machine image based on buildkite AMI
  - monorepo plugin to only build image when that subfolder changes?
- queue hooks to be copied on boostrap

## Later

- trigger first build on pipeline creation, show annotation with guidance (where to store secrets etc.)
- lambda to set org banner on a schedule

## Questions

- Do we generate and store the token in ssm or something else? Or leave it in tf state?

## Issues

- `name` does allot spaces but the docs says it doesn't...
  https://registry.terraform.io/providers/buildkite/buildkite/latest/docs/resources/cluster
