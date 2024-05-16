provider "buildkite" {
  organization = "${var.buildkite_org}"
  # Use the `BUILDKITE_API_TOKEN` environment variable
  # api_token = ""
}

provider "aws" {
  region = "${var.aws_region}"
  default_tags {
    tags = {
      buildkite_org = "${var.buildkite_org}"
      project_id = "${var.project_id}"
    }
  }
}
