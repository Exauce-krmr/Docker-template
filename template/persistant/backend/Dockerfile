# =================================================================================
# TEMPLATE DOCKERFILE - SERVICE PERSISTANT (S'execute en continu)
# =================================================================================

# 1. CHOISIR L'IMAGE DE BASE
# Exemples :
#   FROM ubuntu:latest         (Linux standard avec Bash, recommandé)
#   FROM python:3.9-slim       (Python sur base Debian)
#   FROM node:16-buster        (Node.js sur base Debian)
#   FROM httpd:2.4             (Apache sur base Debian)
FROM <VOTRE_IMAGE_DE_BASE>

# 2. DEFINIR LE REPERTOIRE DE TRAVAIL
# C'est le dossier dans le conteneur où vos commandes seront exécutées
WORKDIR /app

# 3. INSTALLER LES DEPENDANCES
# Sur Ubuntu/Debian, on utilise apt-get.
# Il est recommandé de faire update + install dans la même ligne.
# RUN apt-get update && apt-get install -y curl python3 git

# 4. COPIER VOS FICHIERS
# Copiez uniquement ce qui est nécessaire (code source, config...)
# Exemple : COPY ./src /app/src
COPY <VOTRE_DOSSIER_SOURCE> /<VOTRE_DOSSIER_ARRIVER>

# 5. EXPOSER LES PORTS
# Indiquez à Docker que votre service écoute sur un ou plusieurs ports.
# Cette instruction est informative mais essentielle pour la documentation.
EXPOSE <PORT_DE_VOTRE_SERVICE>

# 6. DEFINIR LA COMMANDE DE DEMARRAGE
# Le script ou la commande qui lance votre service.
#
# ATTENTION : Si le processus s'arrête, le conteneur s'arrête.
# Vous devez utiliser une commande qui reste en premier plan (foreground).
# Exemple :
#   - ENTRYPOINT ["python", "app.py"]
#   - ENTRYPOINT ["nginx", "-g", "daemon off;"]
# - ENTRYPOINT ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
#   - ENTRYPOINT ["java", "-jar", "mon_service.jar"]
#
ENTRYPOINT ["VOTRE_COMMANDE_DE_DEMARRAGE"]