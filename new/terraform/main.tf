# locals {
#   clusters_data = yamldecode(file("${path.module}/../clusters.yaml"))
#   clusters = { for cluster in local.clusters_data["clusters"] : cluster.key => cluster }
#   queues_data = yamldecode(file("${path.module}/../queues.yaml"))
#   queues = { for queue in local.queues_data["queues"] : queue.key => queue }
# }

locals {
  clusters_data = yamldecode(file("${path.module}/../clusters.yaml"))
  clusters = { for cluster in local.clusters_data["clusters"] : cluster.key => cluster }

  queues = flatten([
    for cluster_key, cluster in local.clusters : [
      for queue in lookup(cluster, "queues", []) : merge(queue, { cluster_key = cluster_key })
    ]
  ])
}

resource "buildkite_cluster" "clusters" {
  for_each    = local.clusters
  name        = each.value.name
  description = each.value.description
  emoji       = each.value.emoji
  color       = each.value.color
}

# resource "buildkite_cluster_queue" "queues" {
#   for_each    = local.queues
#   key         = each.value.key
#   description = each.value.description
#   cluster_id  = buildkite_cluster.clusters[each.value.cluster_key].id
# }

resource "buildkite_cluster_queue" "queues" {
  for_each = { for queue in local.queues : "${queue.cluster_key}-${queue.key}" => queue }
  cluster_id  = buildkite_cluster.clusters[each.value.cluster_key].id
  key         = each.value.key
  description = each.value.description
}

output "clusters" {
  value = [
    for cluster in local.clusters : {
      key         = cluster.key
      name        = cluster.name
      description = cluster.description
      emoji       = cluster.emoji
      color       = cluster.color
    }
  ]
}
