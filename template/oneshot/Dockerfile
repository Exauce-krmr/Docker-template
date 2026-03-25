# =================================================================================
# TEMPLATE DOCKERFILE - TACHE ONESHOT (S'execute une fois et s'arrete)
# =================================================================================
# Ce Dockerfile est utilisé pour construire une image qui exécutera un script
# une seule fois, puis s'arrêtera.
#
# Exemples d'usage :
# - Exécuter un script de sauvegarde de base de données
# - Générer un rapport ou un fichier spécifique
# - Lancer une tâche de migration de données
# - Exécuter des tests unitaires
#
# ❓ Vous ne savez pas quelle image choisir ? → docs/Dockerfile.md#2-from--choisir-limage-de-base
# ❓ One-shot ou persistant ?                 → docs/Dockerfile & docker-compose.md
# =================================================================================


# 1. IMAGE DE BASE
# Choisissez l'image qui correspond à votre besoin.
# Exemples :
#   FROM ubuntu:latest       → Linux standard, outils courants disponibles
#   FROM python:3.11-slim    → Python déjà installé
#   FROM node:20-alpine      → Node.js, image très légère
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
# Installez ici les outils dont votre script a besoin.
# ⚠️  Toujours update ET install sur la même ligne pour éviter les problèmes de cache.
#
# ❓ docs/Dockerfile.md#5-run--exécuter-des-commandes-à-la-construction
#
# RUN apt-get update && apt-get install -y <VOTRE_OUTIL> <VOTRE_2EMEOUTIL> <VOTRE_3EMEOUTIL> <ETC...>


# 4. COPIER VOTRE SCRIPT
# Copiez uniquement le fichier nécessaire.
# Le "." signifie : dans le WORKDIR courant (/app).
#
# ❓ docs/Dockerfile.md#4-copy--copier-des-fichiers-dans-limage
COPY script.sh .


# 5. RENDRE LE SCRIPT EXÉCUTABLE
# Nécessaire si votre point d'entrée est un script shell (.sh).
#
# ❓ docs/Dockerfile.md#5-run--exécuter-des-commandes-à-la-construction
RUN chmod +x script.sh


# 6. COMMANDE DE DÉMARRAGE
# C'est ce qui s'exécute quand le conteneur démarre.
# Pour un one-shot, c'est votre script — il s'exécute, puis le conteneur s'arrête.
#
# ❓ docs/Dockerfile.md#6-entrypoint--la-commande-de-démarrage
ENTRYPOINT ["./script.sh"]
