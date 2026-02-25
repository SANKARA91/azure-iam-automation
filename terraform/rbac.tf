# Resource Group pour les devs
resource "azurerm_resource_group" "dev_rg" {
  name     = "rg-dev-team"
  location = "West Europe"
}

# Rôle Contributor pour le groupe DEV sur le RG dev
resource "azurerm_role_assignment" "dev_contributor" {
  scope                = azurerm_resource_group.dev_rg.id
  role_definition_name = "Contributor"
  principal_id         = azuread_group.departments["dev"].object_id
}

# Rôle Reader pour le groupe RH sur la subscription
resource "azurerm_role_assignment" "rh_reader" {
  scope                = "/subscriptions/${var.subscription_id}"
  role_definition_name = "Reader"
  principal_id         = azuread_group.departments["rh"].object_id
}

# Rôle Reader pour le groupe FINANCE sur la subscription
resource "azurerm_role_assignment" "finance_reader" {
  scope                = "/subscriptions/${var.subscription_id}"
  role_definition_name = "Reader"
  principal_id         = azuread_group.departments["finance"].object_id
}

# Rôle Contributor pour le groupe IT sur la subscription
resource "azurerm_role_assignment" "it_contributor" {
  scope                = "/subscriptions/${var.subscription_id}"
  role_definition_name = "Contributor"
  principal_id         = azuread_group.departments["it"].object_id
}