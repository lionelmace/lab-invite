output "user_passwords" {
  value = module.lab_idp.user_and_passwords
}

output "idp_url" {
  value = module.lab_idp.idp_url
}

resource "local_file" "user_passwords" {
  filename = "credentials.csv"
  content = templatefile("./user_passwords.tmpl.csv", {
    user_passwords = module.lab_idp.user_and_passwords
  })
}