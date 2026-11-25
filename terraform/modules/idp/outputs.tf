output "access_group_id" {
  value = ibm_iam_access_group.users.id
}

output "user_and_passwords" {
  value = {
    for value in ibm_appid_cloud_directory_user.user : value.user_name => nonsensitive(value.password)
  }
}
