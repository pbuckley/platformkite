locals {
  clusters_data = yamldecode(file("${path.module}/../clusters.yaml"))
  clusters = { for cluster in local.clusters_data["clusters"] : cluster.key => cluster }
  queues = flatten([
    for cluster_key, cluster in local.clusters : [
      for queue in lookup(cluster, "queues", []) : merge(queue, { cluster_key = cluster_key })
    ]
  ])
  default_queues = [
    for queue in local.queues : queue if queue.default
  ]
}

resource "buildkite_cluster" "clusters" {
  for_each    = local.clusters
  name        = each.value.name
  description = each.value.description
  emoji       = each.value.emoji
  color       = each.value.color
}

resource "buildkite_cluster_queue" "queues" {
  for_each = { for queue in local.queues : "${queue.cluster_key}-${queue.key}" => queue }
  cluster_id  = buildkite_cluster.clusters[each.value.cluster_key].id
  key         = each.value.key
  description = each.value.description
}

resource "buildkite_cluster_default_queue" "default_queues" {
  for_each = { for queue in local.default_queues : "${queue.cluster_key}-${queue.key}" => queue }
  cluster_id  = buildkite_cluster.clusters[each.value.cluster_key].id
  queue_id    = buildkite_cluster_queue.queues[each.key].id
}
