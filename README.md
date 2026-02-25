# 🔐 Azure IAM Automation

Automatisation complète de la gestion des identités et des accès (IAM) sur Azure AD / Microsoft Entra ID via Terraform, Python et GitHub Actions.

## 📋 Description

Ce projet simule un système d'onboarding/offboarding automatisé tel qu'utilisé en entreprise :
- Un fichier CSV simule un export RH
- Un pipeline CI/CD se déclenche automatiquement à chaque modification
- Les comptes Azure AD sont créés ou désactivés automatiquement

## 🏗️ Architecture
```
CSV (RH) → GitHub Actions → Python + Graph API → Azure AD
                                    ↑
                               Terraform
                          (Groupes + RBAC Azure)
```

## 🛠️ Stack technique

| Outil | Usage |
|-------|-------|
| Terraform | Création des groupes AD et assignation RBAC |
| Python | Scripts d'onboarding/offboarding via Graph API |
| Microsoft Graph API | Interaction avec Azure AD |
| GitHub Actions | Pipeline CI/CD automatisé |
| Azure AD / Entra ID | Gestion des identités |

## 📁 Structure du projet
```
azure-iam-automation/
├── .github/
│   └── workflows/
│       └── iam-automation.yml   # Pipeline CI/CD
├── data/
│   └── users.csv                # Fichier RH simulé
├── scripts/
│   ├── graph_client.py          # Connexion à Microsoft Graph API
│   └── onboarding.py            # Script onboarding/offboarding
├── terraform/
│   ├── main.tf                  # Groupes AD et utilisateurs
│   ├── rbac.tf                  # Assignation des rôles Azure
│   ├── variables.tf
│   ├── outputs.tf
│   └── providers.tf
└── README.md
```

## ⚙️ Fonctionnement

### Onboarding
Quand une ligne `onboard` est ajoutée dans `users.csv` :
1. Le pipeline GitHub Actions se déclenche
2. Le script Python appelle Microsoft Graph API
3. Le compte Azure AD est créé avec le bon département
4. L'utilisateur est assigné au groupe AD correspondant

### Offboarding
Quand une ligne `offboard` est ajoutée dans `users.csv` :
1. Le pipeline GitHub Actions se déclenche
2. Le script Python récupère le compte via Graph API
3. Le compte est désactivé immédiatement

## 🚀 Déploiement

### Prérequis
- Terraform >= 1.0
- Python >= 3.11
- Azure CLI
- Un tenant Azure AD

### 1. Configurer l'App Registration Azure
- Créer une App Registration dans Azure AD
- Ajouter les permissions Graph API : `User.ReadWrite.All`, `Group.ReadWrite.All`, `Directory.ReadWrite.All`
- Accorder le consentement administrateur

### 2. Déployer l'infrastructure Terraform
```bash
cd terraform
terraform init
terraform apply
```

### 3. Configurer les secrets GitHub
Ajouter ces secrets dans Settings → Secrets → Actions :
- `ARM_TENANT_ID`
- `ARM_CLIENT_ID`
- `ARM_CLIENT_SECRET`

### 4. Déclencher le pipeline
Modifier le fichier `data/users.csv` et pusher sur main.

## 📝 Format du fichier CSV
```csv
action,first_name,last_name,department,job_title
onboard,Alice,Dupont,dev,Developer
offboard,john.doe,,,
```

| Champ | Description |
|-------|-------------|
| action | `onboard` ou `offboard` |
| first_name | Prénom (ou UPN pour offboard) |
| last_name | Nom |
| department | dev, rh, finance, it |
| job_title | Titre du poste |

## 🔒 Sécurité
- Les secrets sont stockés dans GitHub Secrets
- Aucune credential dans le code source
- Principe du moindre privilège appliqué via RBAC Azure