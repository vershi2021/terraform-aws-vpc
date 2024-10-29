module "vpc" {
  source          = "./modules/vpc"
  name            = var.vpc.name
  cidr            = var.vpc.cidr
  azs             = var.vpc.azs
  private_subnets = var.vpc.private_subnets
  private_subnet_names = [
    for i, subnet in var.vpc.private_subnet_names : "${subnet}-private-${element(var.vpc.azs, i % length(var.vpc.azs))}"
  ]
  public_subnets = var.vpc.public_subnets
  public_subnet_names = [
    for i, subnet in var.vpc.public_subnet_names : "${subnet}-public-${element(var.vpc.azs, i % length(var.vpc.azs))}"
  ]
  enable_nat_gateway     = var.vpc.enable_nat_gateway
  single_nat_gateway     = var.vpc.single_nat_gateway
  one_nat_gateway_per_az = var.vpc.one_nat_gateway_per_az
  tags = {
    Terraform   = "true"
    Environment = var.environment
    Project     = var.project
  }
}

module "eks_cluster" {
  source             = "./modules/eks-cluster"
  cluster_name       = var.eks.cluster_name
  subnet_ids         = module.vpc.private_subnets
  vpc_id             = module.vpc.vpc_id
  environment        = var.environment
  kubernetes_version = var.eks.kubernetes_version
  tags = {
    Terraform   = "true"
    Environment = var.environment
    Project     = var.project
    SelfService = "Eks_Cluster"
  }
  depends_on = [module.vpc]
}

module "eks_node_groups" {
  source          = "./modules/eks-managed-node-group"
  for_each        = var.eks_managed_node_groups
  cluster_name    = each.value.cluster_name
  node_group_name = each.value.node_group_name
  subnet_ids      = module.vpc.private_subnets
  environment     = var.environment
  desired_size    = each.value.node_group_desired_size
  min_size        = each.value.node_group_min_size
  max_size        = each.value.node_group_max_size
  tags = {
    Terraform   = "true"
    Environment = var.environment
    Project     = var.project
  }
  depends_on = [module.eks_cluster]
}


module "s3" {
  source = "./modules/s3"
  for_each = var.s3_buckets
  bucket_name = each.value.bucket_name
  versioning = each.value.versioning
  environment = var.environment
  tags = {
    SelfService = "S3_Bucket"
  }
}