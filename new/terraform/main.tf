locals {
  clusters_data = yamldecode(file("${path.module}/../clusters.yaml"))
  clusters      = { for cluster in local.clusters_data["clusters"] : cluster.key => cluster }
  queues = flatten([
    for cluster_key, cluster in local.clusters : [
      for queue in lookup(cluster, "queues", []) : merge(queue, { cluster_key = cluster_key, key = lookup(queue, "key", "missing-key"), default = lookup(queue, "default", false) })
    ]
  ])
  default_queues = [
    for queue in local.queues : queue if queue.default
  ]

  # Group queues by cluster key and check for multiple default queues
  multiple_default_queues = {
    for cluster_key, cluster in local.clusters : cluster_key => [
      for queue in lookup(cluster, "queues", []) : merge(queue, { key = lookup(queue, "key", "missing-key"), default = lookup(queue, "default", false) }) if lookup(queue, "default", false)
      ] if length([
        for queue in lookup(cluster, "queues", []) : queue if lookup(queue, "default", false)
    ]) > 1
  }

  # Convert the map of clusters with multiple default queues to a string
  multiple_default_queues_str = {
    for cluster_key, queues in local.multiple_default_queues : cluster_key => join(", ", [for queue in queues : queue.key])
  }
}

resource "buildkite_cluster" "clusters" {
  for_each    = local.clusters
  name        = each.value.name
  description = each.value.description
  emoji       = each.value.emoji
  color       = each.value.color
}

resource "buildkite_cluster_queue" "queues" {
  for_each    = { for queue in local.queues : "${queue.cluster_key}-${queue.key}" => queue }
  cluster_id  = buildkite_cluster.clusters[each.value.cluster_key].id
  key         = each.value.key
  description = each.value.description
}

resource "buildkite_cluster_default_queue" "default_queues" {
  for_each   = { for queue in local.default_queues : "${queue.cluster_key}-${queue.key}" => queue }
  cluster_id = buildkite_cluster.clusters[each.value.cluster_key].id
  queue_id   = buildkite_cluster_queue.queues[each.key].id

  lifecycle {
    precondition {
      condition     = !contains(keys(local.multiple_default_queues), each.value.cluster_key)
      error_message = "Validation failed: Cluster '${each.value.cluster_key}' has multiple default queues: ${lookup(local.multiple_default_queues_str, each.value.cluster_key, "none")}"
    }
  }
}