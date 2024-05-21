locals {
  projects_data = yamldecode(file("${path.module}/../projects.yaml"))
  projects = local.projects_data["projects"]
}

output "project_details" {
  value = [for project in local.projects : {
    key         = project.key
    directory   = project.directory
    description = project.description
  }]
}
