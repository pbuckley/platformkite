# locals {
#   clusters_data = yamldecode(file("${path.module}/../simple.yaml"))
#   clusters = { for cluster in local.clusters_data["clusters"] : cluster.name => cluster }
# }

# resource "buildkite_cluster" "cluster" {
#   for_each    = local.clusters
#   name        = each.value.name
#   description = each.value.description
#   emoji       = each.value.emoji
#   color       = each.value.color
# }

# output "project_details" {
#   value = [for cluster in local.clusters : {
#     name        = cluster.name
#     description = cluster.description
#     emoji       = cluster.emoji
#     color       = cluster.color
#   }]
# }

locals {
  projects_data = yamldecode(file("${path.module}/../simple.yaml"))
  projects = { for project in local.projects_data["projects"] : project.key => project }
}

# # Define the Buildkite cluster resource
# resource "buildkite_cluster" "clusters" {
#   for_each = { for project in local.projects : 
#                 project.key => flatten([for cluster in project.value.clusters : 
#                   merge(cluster, { project_key = project.key, project_directory = project.value.directory })])
#               }

#   name        = each.value.name
#   description = each.value.description
#   emoji       = each.value.emoji
#   color       = each.value.color

#   # Example attributes for Buildkite cluster (adjust based on your actual resource and provider)
#   # project_key = each.value.project_key
#   # project_directory = each.value.project_directory
# }

output "cluster_details" {
  value = [
    for project in local.projects : {
      # key = project.key
      # name = project.name
      # directory = project.directory
      # description = project.description
      clusters = [
        for cluster in project.clusters : {
          key = "${project.key}-${cluster.key}"
          name = cluster.name
          description = cluster.description
          emoji = cluster.emoji
          color = cluster.color
        }
      ]
    }
  ]
}

