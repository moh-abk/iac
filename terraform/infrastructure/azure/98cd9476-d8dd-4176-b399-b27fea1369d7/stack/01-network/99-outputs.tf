output "result" {
  value = merge(
    module.network.network_result,
  )
}
