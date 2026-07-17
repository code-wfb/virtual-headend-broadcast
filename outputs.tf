output "vpc_id" {
  value = module.network.vpc_id
}

output "transit_gateway_id" {
  value = module.network.transit_gateway_id
}

output "media_security_group_id" {
  value = module.media.media_security_group_id
}