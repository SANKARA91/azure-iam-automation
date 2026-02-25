output "groups" {
  description = "Groupes AD créés"
  value       = { for k, v in azuread_group.departments : k => v.object_id }
}

output "users" {
  description = "Utilisateurs créés"
  value       = { for k, v in azuread_user.users : k => v.user_principal_name }
}