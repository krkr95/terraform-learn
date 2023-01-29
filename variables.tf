variable "region" {
    type = string
    default = ""
}

variable "vpc_sub" {
    description = "cidr blocks and name for VPC and Subnets of 1 and 2"
    type = list(object({
        cidr_block = string
        name = string
    }))
}

variable "azs" {
    type = list(string)
}

