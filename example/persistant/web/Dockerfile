# Utilisation de l'image officielle Apache
FROM httpd:2.4

# Copie du site web dans le dossier par défaut d'Apache
# COPY ./html/ /usr/local/apache2/htdocs/

# Lancement d'Apache au premier plan (Foreground)
# C'est important pour que le conteneur ne s'arrête pas.
ENTRYPOINT ["/usr/local/apache2/bin/apachectl", "-D", "FOREGROUND"]