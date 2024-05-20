# create a cluster
resource "buildkite_cluster" "my_tf_cluster" {
  name        = "My Terraform Cluster"
  description = "Welcome to my first Terraform cluster!"
  emoji       = ":car:"
  color       = "#DC143C"
}

# add a pipeline
resource "buildkite_pipeline" "my_tf_pipeline" {
  name       = "My Terraform Pipeline"
  repository = "https://github.com/dbr787/platformkite.git"
  color      = "#000000"
  emoji      = ":buildkite:"
  cluster_id = buildkite_cluster.my_tf_cluster.id
  default_branch = "main"
}

# create first queue
resource "buildkite_cluster_queue" "my_first_tf_queue" {
  cluster_id = buildkite_cluster.my_tf_cluster.id
  key        = "my-first-tf-queue"
}

# create second queue
resource "buildkite_cluster_queue" "my_second_tf_queue" {
  cluster_id = buildkite_cluster.my_tf_cluster.id
  key        = "my-second-tf-queue"
}

# set default queue
resource "buildkite_cluster_default_queue" "my_tf_cluster_default_queue" {
  cluster_id = buildkite_cluster.my_tf_cluster.id
  queue_id   = buildkite_cluster_queue.my_first_tf_queue.id
}

# create agent token
resource "buildkite_cluster_agent_token" "my_tf_agent_token" {
  description = "My Terraform Agent Token"
  cluster_id  = buildkite_cluster.my_tf_cluster.id
}

# create agent token with allowed IP range
resource "buildkite_cluster_agent_token" "my_tf_agent_token_ip_limited" {
  description = "My Terraform IP Limited Agent Token"
  cluster_id  = buildkite_cluster.my_tf_cluster.id
  allowed_ip_addresses = ["10.100.1.0/28"]
}

# create a pipeline schedule
resource "buildkite_pipeline_schedule" "my_tf_pipeline_schedule_hourly" {
  pipeline_id = buildkite_pipeline.my_tf_pipeline.id
  label       = "Hourly"
  cronline    = "@hourly"
  branch      = buildkite_pipeline.my_tf_pipeline.default_branch
}

# resource "buildkite_pipeline_template" "template_full" {
#     name = "Production upload"
#     description = "Production upload template"
#     configuration = "steps:\n  - label: \":pipeline:\"\n    command: \"buildkite-agent pipeline upload .buildkite/pipeline-production.yml\"\n"
#     available = true
# }
