output "result" {
  value = merge(
    module.database.db_result,
  )
}
