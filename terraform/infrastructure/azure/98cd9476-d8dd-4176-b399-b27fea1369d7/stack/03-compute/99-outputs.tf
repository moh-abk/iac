output "result" {
  value = merge(
    module.vmss.vmss_result,
  )
}
