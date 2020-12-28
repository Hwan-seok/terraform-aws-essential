
output "alb_dns_name_dev" {
  value = module.web_server_cluster_dev.alb_dns_name
}

output "alb_dns_name_stage" {
  value = module.web_server_cluster_stage.alb_dns_name
}

output "alb_dns_name_real" {
  value = module.web_server_cluster_real.alb_dns_name
}
