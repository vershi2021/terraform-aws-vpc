aws_region  = "us-east-1"
environment = "dev"
project     = "SelfServiceModel1"
vpc = {
  name                   = "dev_vpc"
  azs                    = ["us-east-1a", "us-east-1b"]
  cidr                   = "10.0.0.0/24"
  private_subnets        = ["10.0.0.0/26", "10.0.0.64/26"]
  private_subnet_names   = ["eks", "eks"]
  public_subnets         = ["10.0.0.128/26", "10.0.0.192/26"]
  public_subnet_names    = ["eks", "eks"]
  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
}

eks = {
  cluster_name       = "SelfService_Cluster_eks"
  kubernetes_version = "1.31"
}

eks_managed_node_groups = {
  node-group = {
    cluster_name            = "SelfService_Cluster_eks"
    node_group_name         = "node-group"
    node_group_desired_size = 3
    node_group_min_size     = 1
    node_group_max_size     = 5
  }
}
