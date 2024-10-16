output "vpc" {
    value = aws_vpc.vpc_creation.id
}

output "subnets" {
    value = aws_subnet.public[0].id
}

output "az_zones" {
  value       = local.az_zones
  
}

# output "subnet_map" {
#     value = local.subnet_az_combinations
# }

# output pblic_sub1 {
#   value       = local.pblic_sub1
 
# }



