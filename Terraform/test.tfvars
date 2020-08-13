kops_cluster =  {
  cluster_name ="test"
  dns_zone = "test.net" # Use k8s.local for non route53 records
  kubernetes_version = "1.12.8"
  worker_node_type = "t2.micro"
  min_worker_nodes  = 1
  max_worker_nodes = 2
  master_node_type  = "t2.micro"
  region = "us-west-3"
  state_bucket = "kops-state-bucket123"
  node_image = "kope.io/k8s-1.12-debian-stretch-amd64-hvm-ebs-2019-05-13"
  nodes = [
    {
      name = "frontend",
      role = "agent",
      instanceType = "t2.micro"
      minSize = 1,
      maxSize = 2,
    },
    {
      name = "backend",
      role = "agent",
      instanceType = "t2.micro"
      minSize = 1,
      maxSize = 2,
    }
  ]
}
