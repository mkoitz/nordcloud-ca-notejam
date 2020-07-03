data "aws_caller_identity" "current" {
}

locals {
    application        = "notejam-spring"
    aws_account        = data.aws_caller_identity.current.account_id
    docker_tag         = "latest" // get proper version

    // devide into public an private
    subnet_ids = ["subnet-0623144e", "subnet-1aa4807c", "subnet-bf7110e5"]

    tags = {
        Environment = terraform.workspace
        Project     = local.application
    }
}
