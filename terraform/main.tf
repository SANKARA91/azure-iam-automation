# Récupère les infos du tenant courant
data "azuread_client_config" "current" {}

# Crée un groupe AD par département
resource "azuread_group" "departments" {
  for_each     = toset(var.departments)
  display_name = "GRP-${upper(each.value)}"
  description  = "Groupe du département ${each.value}"
  security_enabled = true
}

# Crée des utilisateurs de test
resource "azuread_user" "users" {
  for_each            = local.users
  display_name        = each.value.display_name
  user_principal_name = "${each.key}@${var.domain}"
  password            = each.value.password
  department          = each.value.department
  job_title           = each.value.job_title
}

# Assigne chaque utilisateur à son groupe de département
resource "azuread_group_member" "assignments" {
  for_each         = local.users
  group_object_id  = azuread_group.departments[each.value.department].object_id
  member_object_id = azuread_user.users[each.key].object_id
}