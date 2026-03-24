# Utilisation d'une image Linux standard (Ubuntu)
# C'est plus simple pour les débutants car elle inclut Bash et les outils habituels.
FROM ubuntu:latest

# Mise à jour des dépôts et installation de l'outil 'pwgen'
# On utilise apt-get sur Ubuntu/Debian (au lieu de apk sur Alpine)
RUN apt-get update && apt-get install -y pwgen

# Définition du dossier de travail
WORKDIR /app

# Copie du script local vers le conteneur
COPY script.sh .

# Rendre le script exécutable
RUN chmod +x script.sh

# Création du dossier où seront stockés les résultats
RUN mkdir /output

# Point d'entrée : Ce qui s'exécute quand on lance le conteneur
ENTRYPOINT ["./script.sh"]