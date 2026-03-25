# =================================================================================
# TEMPLATE DOCKERFILE - SERVICE PERSISTANT (Tourne en continu)
# =================================================================================
# Ce Dockerfile est utilisé pour construire un service qui reste actif en
# attendant des connexions : serveur web, API, base de données custom...
#
# Exemples d'usage :
# - Serveur web (Apache, Nginx...)
# - API REST (Python/Flask, Node.js/Express...)
# - Service de traitement en continu
#
# ❓ Vous ne savez pas quelle image choisir ? → docs/Dockerfile.md#2-from--choisir-limage-de-base
# ❓ One-shot ou persistant ?                 → docs/Dockerfile & docker-compose.md
# =================================================================================


# 1. IMAGE DE BASE
# Choisissez l'image qui correspond à votre besoin.
# Exemples :
#   FROM ubuntu:24.04            → Linux standard, polyvalent
#   FROM python:3.11-slim        → Python déjà installé
#   FROM node:20-alpine          → Node.js, image très légère
#   FROM httpd:2.4               → Serveur Apache prêt à l'emploi
#
# ❓ docs/Dockerfile.md#2-from--choisir-limage-de-base
FROM <VOTRE_IMAGE_DE_BASE>


# 2. RÉPERTOIRE DE TRAVAIL
# Définit le dossier courant dans le conteneur.
# Toutes les instructions suivantes (COPY, RUN, ENTRYPOINT) s'exécutent depuis ici.
#
# ❓ docs/Dockerfile.md#3-workdir--définir-le-répertoire-de-travail
WORKDIR /app


# 3. INSTALLER LES DÉPENDANCES  (optionnel — décommenter si besoin)
# Installez ici les outils et librairies dont votre service a besoin.
# ⚠️  Toujours update ET install sur la même ligne pour éviter les problèmes de cache.
#
# ❓ docs/Dockerfile.md#5-run--exécuter-des-commandes-à-la-construction
#
# RUN apt-get update && apt-get install -y <VOTRE_OUTIL>


# 4. COPIER VOS FICHIERS
# Copiez votre code source ou les fichiers nécessaires au service.
# Format : COPY <source_sur_votre_pc> <destination_dans_le_conteneur>
#
# ❓ docs/Dockerfile.md#4-copy--copier-des-fichiers-dans-limage
COPY <VOTRE_DOSSIER_SOURCE> <VOTRE_DOSSIER_DESTINATION>


# 5. COMMANDE DE DÉMARRAGE
# C'est ce qui lance votre service quand le conteneur démarre.
# ⚠️  Le processus doit rester en PREMIER PLAN (foreground), sinon le conteneur
#     s'arrête immédiatement en croyant que le travail est terminé.
#
# Exemples :
#   ENTRYPOINT ["python", "app.py"]
#   ENTRYPOINT ["node", "index.js"]
#   ENTRYPOINT ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
#   ENTRYPOINT ["nginx", "-g", "daemon off;"]
#
# ❓ docs/Dockerfile.md#6-entrypoint--la-commande-de-démarrage
ENTRYPOINT ["<VOTRE_COMMANDE_DE_DEMARRAGE>"]
