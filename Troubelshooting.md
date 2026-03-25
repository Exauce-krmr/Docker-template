# ️Troubleshooting (Dépannage)

Si un conteneur ne démarre pas ou se comporte anormalement, suivez ce guide par étapes.

## 1. Diagnostic de base
Avant toute chose, vérifiez l'état de vos services :
* `docker ps -a` : Pour voir si un conteneur a crashé (cherchez la colonne `STATUS`).
* `docker logs -f <nom_conteneur>` : **L'étape la plus importante.** Affiche les erreurs d'application (erreurs de code, base de données manquante, etc.).

## 2. Problèmes fréquents

### 🛑 Le conteneur s'arrête immédiatement
* **Cause** : Le processus principal s'est terminé ou a rencontré une erreur.
* **Solution** : Vérifiez les logs. Si vous testez une image de base (ex: Ubuntu), elle s'arrête car elle n'a rien à faire. Ajoutez `-it` ou une commande de veille : `docker run -d ubuntu sleep infinity`.

### 🌐 Problèmes de ports (Connection Refused)
* **Conflit d'hôte** : L'erreur `Bind for 0.0.0.0:80 failed` signifie que votre PC utilise déjà le port 80.
    * *Fix* : Changez le port gauche : `-p 8080:80`.
* **Mauvaise interface** : Votre application interne doit écouter sur `0.0.0.0` et non `127.0.0.1` pour être accessible depuis l'extérieur du conteneur.

### 📁 Problèmes de Volumes / Permissions
* **Fichiers non mis à jour** : Sur Windows/Mac, les changements de fichiers mettent parfois du temps à se synchroniser. Redémarrez le conteneur.
* **Permission denied** : Docker tourne souvent en `root`. Si vous avez des soucis d'écriture, vérifiez les droits du dossier sur l'hôte.

## 3. "The Nuclear Option" (Quand rien ne marche)
Parfois, Docker garde en cache des couches d'images ou des volumes corrompus.

```bash
# Force la reconstruction sans utiliser le cache
docker-compose build --no-cache

# Recrée les conteneurs de zéro
docker-compose up --force-recreate

# Nettoyage des volumes orphelins (Attention : perte de données possible)
docker volume prune