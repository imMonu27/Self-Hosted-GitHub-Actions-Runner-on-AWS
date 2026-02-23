terraform {
  source = "../terraform/"
}

inputs = merge(
  yamldecode(file("config.yml")),
  {
    vpc_id     = "",
    ami        = "ami-012ac75dc64f286d9",
    github_pat = "",
    region     = "us-east-1"
    
  }
)
