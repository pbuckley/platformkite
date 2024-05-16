# main and tagging
aws_region             = "ap-southeast-2"
project_id             = "dbr"
email                  = "daniel.ring@puppet.com"
public_zone_name       = "aws.tsedemos.com"
private_zone_name      = "aws.tsedemos.com"
create_vpc_and_subnets = true
vpc_cidr               = "10.66.0.0/16"
public_subnet_a_cidr   = "10.66.1.0/24"
public_subnet_b_cidr   = "10.66.2.0/24"
allowed_ip_cidrs       = ["119.18.25.84/32"]

# puppet enterprise
pe_version                 = "latest"
pe_primary_instance_type   = "c5a.4xlarge"
pe_primary_ssh_user        = "ec2-user"
pe_primary_ami_owner       = "309956199498"
pe_primary_ami_name_filter = "RHEL-7.9_HVM_GA*"
pe_primary_role            = "role::pe_primary"
pe_primary_environment     = "production"
control_repo               = "git@github.com:dbr787/puppet-tf-demo-control-repo.git"
github_token               = "~/.github_puppet_pat"
eyaml_private_key          = "~/.eyaml/private_key.pkcs7.pem"
eyaml_public_key           = "~/.eyaml/public_key.pkcs7.pem"

# nodes
nodes = [
  {
    id              = "p01nix",
    platform        = "linux"
    instance_count  = 1
    instance_type   = "t2.small"
    ssh_user        = "ec2-user"
    ami_owner       = "309956199498"
    ami_name_filter = "RHEL-7.9_HVM_GA*"
    role            = "role::nix_generic"
    environment     = "production"
  },
  {
    id              = "p01win"
    platform        = "windows"
    instance_count  = 2
    instance_type   = "c5a.4xlarge"
    ami_owner       = "801119661308"
    ami_name_filter = "Windows_Server-2019-English-Full-Base-*"
    role            = "role::win_generic"
    environment     = "production"
  },
  {
    id              = "p02win"
    platform        = "windows"
    instance_count  = 1
    instance_type   = "t2.medium"
    ami_owner       = "801119661308"
    ami_name_filter = "Windows_Server-2019-English-Full-Base-*"
    role            = "role::win_generic"
    environment     = "production"
  }
  # {
  #   id              = "p02nix",
  #   platform        = "linux"
  #   instance_count  = 1
  #   instance_type   = "t2.medium"
  #   ssh_user        = "ec2-user"
  #   ami_owner       = "309956199498"
  #   ami_name_filter = "RHEL-7.9_HVM_GA*"
  #   role            = "role::nix_generic"
  #   environment     = "production"
  # },
  # {
  #   id              = "p02win"
  #   platform        = "windows"
  #   instance_count  = 1
  #   instance_type   = "t2.medium"
  #   ami_owner       = "801119661308"
  #   ami_name_filter = "Windows_Server-2019-English-Full-Base-*"
  #   role            = "role::win_generic"
  #   environment     = "production"
  # },
  # {
  #   id              = "p02win"
  #   platform        = "windows"
  #   instance_count  = 1
  #   instance_type   = "t2.small"
  #   ami_owner       = "801119661308"
  #   ami_name_filter = "Windows_Server-2019-English-Full-Base-2021*"
  #   role            = "role::win_generic2"
  #   environment     = "production"
  # },
]
