# =================================================================================
# EXEMPLE DOCKERFILE - SERVICE PERSISTANT : Serveur web Apache
# =================================================================================
# Ce Dockerfile construit une image Apache qui sert les fichiers HTML
# présents dans ./html. Le serveur tourne en continu.
#
# ❓ One-shot ou persistant ? → docs/Dockerfile & docker-compose.md
# =================================================================================


# On part de l'image officielle Apache (httpd).
# Elle inclut déjà Apache configuré et prêt à l'emploi.
# ❓ docs/Dockerfile.md#2-from--choisir-limage-de-base
FROM httpd:2.4


# Définition du dossier de travail dans le conteneur.
# ❓ docs/Dockerfile.md#3-workdir--définir-le-répertoire-de-travail
WORKDIR /usr/local/apache2/htdocs


# Copie du fichier HTML par défaut dans le dossier servi par Apache.
# En production, ce fichier sera remplacé par le volume dans docker-compose.yml,
# ce qui permet de modifier les pages sans reconstruire l'image.
# ❓ docs/Dockerfile.md#4-copy--copier-des-fichiers-dans-limage
COPY ./html/index.html .


# Apache démarre automatiquement au lancement de l'image httpd:2.4.
# Pas besoin d'ENTRYPOINT ici — l'image officielle le gère déjà.
#
# Si vous construisez depuis une image de base (ubuntu, debian...) et installez
# Apache manuellement, vous auriez besoin de :
#   ENTRYPOINT ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
# ❓ docs/Dockerfile.md#6-entrypoint--la-commande-de-démarrage
