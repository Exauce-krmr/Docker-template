# =================================================================================
# TEMPLATE DOCKERFILE - TACHE ONESHOT (S'execute une fois et s'arrete)
# =================================================================================
#
# Ce Dockerfile est utilisé pour construire une image qui exécutera un script une seule fois, puis s'arrêtera.
#
# Exemples d'usage :
# - Exécuter un script de sauvegarde de base de données
# - Générer un rapport ou un fichier spécifique
# - Lancer une tâche de migration de données
# - Exécuter des tests unitaires ou d'intégration

# 1. CHOISIR L'IMAGE DE BASE
# Exemple : FROM ubuntu:latest
FROM <VOTRE_IMAGE_DE_BASE>

# 2. DEFINIR LE REPERTOIRE DE TRAVAIL
# C'est le dossier par défaut où vos commandes seront exécutées dans le conteneur.
# En gros c'est juste un cd dans le dockerfile
# WORKDIR /app

# 3. INSTALLER LES DEPENDANCES (Optionnel)
# Il est recommandé de faire update + install dans la même ligne pour éviter les problèmes de cache.
# RUN apt-get update && apt-get install -y curl python3 git

# 4. COPIER VOS FICHIERS
# Copiez uniquement le script nécessaire.
COPY script.sh .

# 5. RENDRE LE SCRIPT EXECUTABLE
# Si votre point d'entrée est un script shell (comme script.sh), il doit être exécutable.
RUN chmod +x script.sh

# 6. DEFINIR LA COMMANDE DE DEMARRAGE (ENTRYPOINT)
# C'est la commande principale qui sera exécutée lorsque le conteneur démarre. (Une fois que l'image a été créer)
# Pour un one-shot, c'est  votre script

ENTRYPOINT ["./script.sh"]