variable "region" {
  type    = string
  default = "us-east-1"  # change if you prefer another region
}

variable "cluster_name" {
  type    = string
  default = "regapp-eks-cluster"
}

variable "node_instance_type" {
  type    = string
  default = "t3.small"
}

variable "node_desired_capacity" {
  type    = number
  default = 2
}

variable "node_min_capacity" {
  type    = number
  default = 1
}

variable "node_max_capacity" {
  type    = number
  default = 3
}
