locals {
  prefix = lower("${var.project}-${var.environment}")
  
}

resource "buildkite_agent_token" "elastic_stack" {
  description = "Elastic stack"
}

resource "aws_cloudformation_stack" "buildkite_agent_default" {
  name         = "buildkite-agent-default"
  template_url = "https://s3.amazonaws.com/buildkite-aws-stack/master/aws-stack.yml"
  capabilities = ["CAPABILITY_NAMED_IAM"]
  parameters = {
    AgentsPerInstance        = 5
    AssociatePublicIpAddress = true
    InstanceType             = "i3.2xlarge"
    MaxSize                  = 10
    MinSize                  = 0
    RootVolumeSize           = 50
    BuildkiteAgentToken      = buildkite_agent_token.elastic_stack.token
  }
}

