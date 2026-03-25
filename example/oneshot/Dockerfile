# =================================================================================
# EXEMPLE DOCKERFILE - TACHE ONESHOT : Générateur de mot de passe
# =================================================================================
# Ce conteneur génère un mot de passe sécurisé, l'écrit dans un fichier,
# puis s'arrête.
#
# ❓ One-shot ou persistant ? → docs/Dockerfile & docker-compose.md
# =================================================================================


# On part d'Ubuntu car pwgen est facilement installable avec apt-get.
# ❓ docs/Dockerfile.md#2-from--choisir-limage-de-base
FROM ubuntu:latest


# Installation de l'outil pwgen (générateur de mots de passe).
# ⚠️  update et install toujours sur la même ligne.
# ❓ docs/Dockerfile.md#5-run--exécuter-des-commandes-à-la-construction
RUN apt-get update && apt-get install -y pwgen


# Définition du dossier de travail dans le conteneur.
# ❓ docs/Dockerfile.md#3-workdir--définir-le-répertoire-de-travail
WORKDIR /app


# Copie du script local vers le dossier de travail du conteneur.
# ❓ docs/Dockerfile.md#4-copy--copier-des-fichiers-dans-limage
COPY script.sh .


# Le script doit être exécutable pour pouvoir être lancé par ENTRYPOINT.
# ❓ docs/Dockerfile.md#5-run--exécuter-des-commandes-à-la-construction
RUN chmod +x script.sh


# Création du dossier de sortie où le script écrira le résultat.
# Ce dossier sera lié à votre machine via le volume dans docker-compose.yml.
# ❓ docs/Dockerfile.md#5-run--exécuter-des-commandes-à-la-construction
RUN mkdir /output


# Le script s'exécute au démarrage du conteneur, puis le conteneur s'arrête.
# ❓ docs/Dockerfile.md#6-entrypoint--la-commande-de-démarrage
ENTRYPOINT ["./script.sh"]
