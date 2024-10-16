#vpc creation
resource "aws_vpc" "vpc_creation" {
  cidr_block       = var.cidr_block
  instance_tenancy = var.instance_tenancy
  tags = var.tags
}

# igw creation

resource "aws_internet_gateway" "main" {
  vpc_id = local.vpc_id
  tags = var.int_gtw_tag
}

# subnets Creation
resource "aws_subnet" "public" {
  count      = length(var.public_subnet)
  vpc_id     = local.vpc_id
  cidr_block = var.public_subnet[count.index]
  availability_zone = local.az_zones[count.index]
  map_public_ip_on_launch = var.public_ip
  tags = merge (
    var.common_tags,
    var.env,
    {
    Name = "${var.project}-${var.Environment}-public-${local.az_zones[count.index]}"
    })
 }

# private subnets Creation
resource "aws_subnet" "private" {
  count      = length(var.private_subnet)
  vpc_id     = local.vpc_id
  cidr_block = var.private_subnet[count.index]
  availability_zone = local.az_zones[count.index]
  tags = merge (
    var.common_tags,
    var.env,
    {
    Name = "${var.project}-${var.Environment}-private-${local.az_zones[count.index]}"
    })
}


# database subnets Creation
resource "aws_subnet" "database" {
  count      = length(var.database_subnet)
  vpc_id     = local.vpc_id
  cidr_block = var.database_subnet[count.index]
  availability_zone = local.az_zones[count.index]
  tags = merge (
    var.common_tags,
    var.env,
    {
    Name = "${var.project}-${var.Environment}-database-${local.az_zones[count.index]}"
    })
}

# database group creation for database subnet
resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = aws_subnet.database[*].id

   tags = merge (
    var.common_tags,
    var.env,
    {
    Name = "${var.project}-database"
  })
}
# create eastic IP values 
resource "aws_eip" "main" {
  domain   = var.vpc
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.main.id
  subnet_id     = aws_subnet.public[0].id
   tags = merge (
    var.common_tags,
    var.env,
    {
    Name = "${var.project}-dev"
    })
  depends_on = [aws_internet_gateway.main]
}

# public route table
resource "aws_route_table" "public" {
  vpc_id = local.vpc_id
   tags = merge (
    var.common_tags,
    var.env,
    {
    Name = "${var.project}-${var.Environment}-public"
    })
}

# private route table
resource "aws_route_table" "private" {
  vpc_id = local.vpc_id

   tags = merge (
    var.common_tags,
    var.env,
    {
    Name = "${var.project}-${var.Environment}-private"
    })
}


# database route table
resource "aws_route_table" "database" {
  vpc_id = local.vpc_id
   tags = merge (
    var.common_tags,
    var.env,
    {
    Name = "${var.project}-${var.Environment}-database"
    })
}
# Route table association
resource "aws_route" "public" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = var.dest_cidr_block
  gateway_id = aws_internet_gateway.main.id
}
resource "aws_route" "private_nat" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = var.dest_cidr_block
  nat_gateway_id = aws_nat_gateway.main.id
}
resource "aws_route" "database_nat" {
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = var.dest_cidr_block
  nat_gateway_id = aws_nat_gateway.main.id
}

# public route to subnet association
resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public[*])
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# private route to subnet association
resource "aws_route_table_association" "private" {
  count = length(aws_subnet.private[*])
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

# database route to subnet association
resource "aws_route_table_association" "database" {
  count = length(aws_subnet.database[*])
  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database.id
}

resource "aws_ssm_parameter" "vpc_id" {
  name        = "/expense/dev/vpc_id"
  description = "The parameter description"
  type        = "SecureString"
  value       = local.vpc_id

  tags = {
    environment = "${var.project}-dev"
  }
}

locals  {
vpc_id =  aws_vpc.vpc_creation.id
}

locals  {
az_zones = slice(data.aws_availability_zones.available.names,0,2)
}




# locals {
  
#   subnet_az_combinations = flatten([
#     for subnet,cidr_list in var.practice_subnet : [
#       for idx,az in cidr_list : {
#         "${subnet}-${idx}"    = az
#       }
#     ]
#   ])
# }

  

# locals {
# # pblic_sub = flatten([for i in keys(var.practice_subnet) : i])[*]
# pblic_sub = [for value in var.practice_subnet : value]
# }
 
# locals {
# # pblic_sub = flatten([for i in keys(var.practice_subnet) : i])[*]
# pblic_sub1 = [for k,value in var.practice_subnet : value]
# }
