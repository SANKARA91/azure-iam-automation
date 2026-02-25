variable "departments" {
  description = "Liste des départements de l'entreprise"
  type        = list(string)
  default     = ["dev", "rh", "finance", "it"]
}

variable "company_name" {
  description = "Nom de l'entreprise"
  type        = string
  default     = "brsankara"
}

variable "domain" {
  description = "Domaine Azure AD"
  type        = string
}

variable "client_secret" {
  description = "Client secret de l'App Registration"
  type        = string
  sensitive   = true
}

variable "subscription_id" {
  description = "ID de la subscription Azure"
  type        = string
}