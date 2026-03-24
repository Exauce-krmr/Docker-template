#!/bin/bash

# =============================================================================
# EXEMPLE DE SCRIPT ONESHOT
# Ce script génère un mot de passe sécurisé et le sauvegarde.
# Il est exécuté une seule fois par le conteneur, puis le conteneur s'arrête.
# =============================================================================

echo "--- Démarrage du générateur de mot de passe ---"

# Utilisation des variables d'environnement (définies dans docker-compose.yml)
# Si la variable LONGUEUR_MDP n'est pas définie, on utilise 16 par défaut.
LENGTH=${LONGUEUR_MDP:-16}
OUTPUT_FILE=${FICHIER_RESULTAT:-password.txt}

echo "Configuration :"
echo "  - Longueur : $LENGTH caractères"
echo "  - Fichier de sortie : /output/$OUTPUT_FILE"

# Génération du mot de passe
# pwgen -s (sécurisé) -y (symboles)
PASSWORD=$(pwgen -s -y 1 $LENGTH)

echo "Mot de passe généré : $PASSWORD"

# Écriture dans le volume partagé
# Le dossier /output dans le conteneur correspond au dossier ./resultats sur votre PC
echo "$PASSWORD" > "/output/$OUTPUT_FILE"

echo "--- Terminée ! Vérifiez le dossier 'resultats' ---"