import asyncio
import pandas as pd
import os
from graph_client import get_graph_client
from msgraph.generated.models.user import User
from msgraph.generated.models.password_profile import PasswordProfile

TENANT_ID     = os.environ.get("ARM_TENANT_ID")
CLIENT_ID     = os.environ.get("ARM_CLIENT_ID")
CLIENT_SECRET = os.environ.get("ARM_CLIENT_SECRET")
DOMAIN        = "brsankaraoutlook.onmicrosoft.com"

async def onboard_user(client, row):
    upn = f"{row['first_name'].lower()}.{row['last_name'].lower()}@{DOMAIN}"
    print(f"🔄 Création de : {upn}")
    
    # Vérifie si l'utilisateur existe déjà
    try:
        existing = await client.users.by_user_id(upn).get()
        if existing:
            print(f"⚠️ Utilisateur déjà existant, skip : {upn}")
            return
    except Exception:
        pass  # L'utilisateur n'existe pas, on continue

    try:
        user = User(
            display_name=f"{row['first_name']} {row['last_name']}",
            user_principal_name=upn,
            mail_nickname=f"{row['first_name'].lower()}.{row['last_name'].lower()}",
            department=row['department'],
            job_title=row['job_title'],
            account_enabled=True,
            password_profile=PasswordProfile(
                password="TempPass123!",
                force_change_password_next_sign_in=True
            )
        )
        await client.users.post(user)
        print(f"✅ Utilisateur créé : {upn}")
    except Exception as e:
        print(f"❌ Erreur lors de la création de {upn} : {e}")

async def offboard_user(client, row):
    upn = f"{row['first_name']}@{DOMAIN}"
    print(f"🔄 Désactivation de : {upn}")
    users = await client.users.get()
    target = next((u for u in users.value if u.user_principal_name == upn), None)
    if target:
        await client.users.by_user_id(target.id).patch(User(account_enabled=False))
        print(f"🔴 Utilisateur désactivé : {upn}")
    else:
        print(f"⚠️ Utilisateur introuvable : {upn}")

async def main():
    print("🚀 Démarrage du script...")
    print(f"Tenant ID: {TENANT_ID}")
    
    if not TENANT_ID or not CLIENT_ID or not CLIENT_SECRET:
        print("❌ Variables d'environnement manquantes !")
        return

    df = pd.read_csv("../data/users.csv")
    print(f"📋 {len(df)} utilisateurs trouvés dans le CSV")

    client = get_graph_client(TENANT_ID, CLIENT_ID, CLIENT_SECRET)

    for _, row in df.iterrows():
        if row['action'] == 'onboard':
            await onboard_user(client, row)
        elif row['action'] == 'offboard':
            await offboard_user(client, row)

if __name__ == "__main__":
    asyncio.run(main())