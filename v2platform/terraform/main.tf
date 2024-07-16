locals {

  project = "platformkite"

  yaml = yamldecode(file("${path.module}/../clusters.yaml"))

  # defaults
  defaults = local.yaml["defaults"]

  # clusters - use top-level parent key defaults if provided in defaults
  clusters = [for cluster in local.yaml["clusters"] : {
    key            = cluster.key # required
    name           = cluster.name # required
    description    = lookup(cluster, "description", lookup(local.defaults, "clusters.description", null))
    emoji          = lookup(cluster, "emoji", lookup(local.defaults, "clusters.emoji", null))
    color          = lookup(cluster, "color", lookup(local.defaults, "clusters.color", null))
    default_queue  = lookup(cluster, "default_queue", lookup(local.defaults, "clusters.default_queue", null))
    queues         = lookup(cluster, "queues", lookup(local.defaults, "clusters.queues", null))
    tokens         = lookup(cluster, "tokens", lookup(local.defaults, "clusters.tokens", null))
  }]
  
  # queues - use child key defaults if not provided
  queues = flatten([for cluster in local.clusters : [
    for queue in cluster.queues : {
      key            = queue.key # required
      cluster_key    = cluster.key # inherited
      description    = lookup(queue, "description", lookup(local.defaults, "clusters.queues.description", null))
      # agents         = lookup(queue, "agents", [])
      agents         = lookup(queue, "agents", lookup(local.defaults, "clusters.queues.agents", []))
    }
  ]])

  # tokens - use child key defaults if not provided
  tokens = flatten([for cluster in local.clusters : [
    for token in cluster.tokens : {
      key                   = token.key # required
      cluster_key           = cluster.key # inherited
      description           = lookup(token, "description", lookup(local.defaults, "clusters.tokens.description", null))
      allowed_ip_addresses  = lookup(token, "allowed_ip_addresses", lookup(local.defaults, "clusters.tokens.allowed_ip_addresses", []))
    }
  ]])

  # agents - combine agents data for each queue
  agents = flatten([for queue in local.queues : [
    for agent in queue.agents : {
      type                        = agent.type # required
      queue_key                   = queue.key  # inherited
      cluster_key                 = queue.cluster_key # inherited
      token_key                   = agent.token_key # inherited
      config                      = agent.config # required
    }
  ]])
  
}

# create buildkite clusters
resource "buildkite_cluster" "clusters" {
  for_each = { for cluster in local.clusters : cluster.key => cluster }
  name        = each.value.name
  description = each.value.description
  emoji       = each.value.emoji
  color       = each.value.color
}

# create buildkite cluster queues
resource "buildkite_cluster_queue" "queues" {
  for_each = { for queue in local.queues : "${queue.cluster_key}-${queue.key}" => queue }
  cluster_id  = buildkite_cluster.clusters[each.value.cluster_key].id
  key         = each.value.key
  description = each.value.description
}

# configure buildkite cluster default queues
resource "buildkite_cluster_default_queue" "default_queues" {
  for_each = {
    for cluster in local.clusters : cluster.key => cluster
    if cluster.default_queue != null
  }
  cluster_id = buildkite_cluster.clusters[each.key].id
  queue_id   = buildkite_cluster_queue.queues["${each.key}-${each.value.default_queue}"].id
}

# create buildkite cluster agent tokens
resource "buildkite_cluster_agent_token" "tokens" {
  for_each = { for token in local.tokens : "${token.cluster_key}-${token.key}" => token }
  cluster_id            = buildkite_cluster.clusters[each.value.cluster_key].id
  description           = each.value.description
  allowed_ip_addresses  = each.value.allowed_ip_addresses
}

# store buildkite cluster agent tokens in aws ssm parameter store
resource "aws_ssm_parameter" "tokens" {
  for_each = { for token in local.tokens : "${token.cluster_key}-${token.key}" => token }
  name        = "/${local.project}/agent-tokens/${each.value.cluster_key}/${each.value.key}"
  description = "${each.value.key} token for ${each.value.cluster_key} cluster"
  type        = "String"
  value       = buildkite_cluster_agent_token.tokens[each.key].token
}



output "agents" {
  value = local.agents
}

# output "tokens" {
#   value = local.tokens
# }

# output "queues" {
#   value = local.queues
# }