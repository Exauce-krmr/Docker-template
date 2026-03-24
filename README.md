# Docker Templates & Examples

Ce projet contient des modèles (**Templates**) prêts à l'emploi et des exemples concrets pour vous aider à démarrer avec Docker. 
Il sert également de **référence technique**.

## Structure du Projet

*   **`template/`** : Des bases propres à copier-coller.
    *   **`oneshot/`** : Pour des scripts qui s'exécutent une fois (backup, traitement...).
    *   **`persistant/`** : Pour des serveurs (Web, BDD...) qui tournent en continu.
*   **`example/`** : Des démonstrations fonctionnelles.
    *   **`oneshot/`** : Un générateur de mot de passe.
    *   **`persistant/`** : Un site Web Apache + Base de données MySQL.

---

## CheatSheet

Cliquez sur une commande pour voir les détails.

### Conteneurs (Cycle de vie)
| Commande | Description |
| :--- | :--- |
| [`docker run`](#docker-run) | Créer et démarrer un conteneur |
| [`docker ps`](#docker-ps) | Lister les conteneurs actifs |
| [`docker stop`](#docker-stop) | Arrêter un conteneur proprement |
| [`docker start`](#docker-start) | Relancer un conteneur arrêté |
| [`docker rm`](#docker-rm) | Supprimer un conteneur |

### Interaction & Debug
| Commande | Description |
| :--- | :--- |
| [`docker exec`](#docker-exec) | Exécuter une commande DANS le conteneur |
| [`docker logs`](#docker-logs) | Voir les logs (sortie standard) |
| [`docker cp`](#docker-cp) | Copier des fichiers (PC ↔ Conteneur) |

### Images
| Commande | Description |
| :--- | :--- |
| [`docker images`](#docker-images) | Lister les images téléchargées |
| [`docker pull`](#docker-pull) | Télécharger une image |
| [`docker build`](#docker-build) | Construire une image (Dockerfile) |
| [`docker rmi`](#docker-rmi) | Supprimer une image |

### Docker Compose
| Commande | Description |
| :--- | :--- |
| [`docker-compose up`](#docker-compose-up) | Démarrer tout le projet |
| [`docker-compose down`](#docker-compose-down) | Tout arrêter et supprimer |
| [`docker-compose logs`](#docker-compose-logs) | Voir les logs de tous les services |
| [`docker-compose ps`](#docker-compose-ps) | État des services |
| [`docker-compose exec`](#docker-compose-exec) | Entrer dans un service |

---

## Documentation

### `docker run`
**Crée et démarre un nouveau conteneur.**
*   **Usage** : `docker run [OPTIONS] IMAGE [COMMANDE]`
*   **Options** :
    *   `-d` : Detach (arrière-plan).
    *   `-p 80:80` : Mappe les ports (Hôte:Conteneur).
    *   `-v ./data:/app/data` : Monte un volume.
    *   `--rm` : Supprime le conteneur à la fin.
    *   `--name mon_nom` : Nomme le conteneur.
*   **Exemple** : `docker run -d -p 8080:80 --name mon_site nginx`

### `docker ps`
**Liste les conteneurs.**
*   `docker ps` : Uniquement ceux en cours d'exécution.
*   `docker ps -a` : Tous (y compris les arrêtés).
*   `docker ps -q` : Affiche juste les IDs.

### `docker stop` / `docker start`
**Arrête ou relance un conteneur.**
*   `docker stop mon_conteneur` : Arrêt propre (SIGTERM).
*   `docker start mon_conteneur` : Relance un conteneur arrêté.

### `docker rm`
**Supprime un conteneur.**
*   `docker rm mon_conteneur` : Doit être arrêté avant.
*   `docker rm -f mon_conteneur` : Force la suppression.

---

### `docker exec`
**Exécute une commande dans un conteneur actif.**
*   `docker exec -it mon_conteneur bash` : Ouvre un terminal (bash).
*   `docker exec mon_conteneur ls /app` : Liste les fichiers sans entrer dedans.

### `docker logs`
**Affiche les journaux (stdout/stderr).**
*   `docker logs -f mon_conteneur` : Suit les logs en direct (Ctrl+C pour quitter).
*   `docker logs --tail 100 mon_conteneur` : Les 100 dernières lignes.

### `docker cp`
**Copie des fichiers entre l'hôte et le conteneur.**
*   `docker cp mon_fichier.txt mon_conteneur:/app/` : Vers le conteneur.
*   `docker cp mon_conteneur:/app/config.json .` : Depuis le conteneur.

---

### `docker images`
**Liste les images locales.**
*   Affiche la taille, la date de création et l'ID.

### `docker pull`
**Télécharge une image depuis le Hub.**
*   `docker pull python:3.9` : Télécharge une version spécifique.

### `docker build`
**Construit une image à partir d'un Dockerfile.**
*   `docker build -t mon_image:v1 .` : Construit depuis le dossier courant (`.`) et tag l'image (`-t`).

### `docker rmi`
**Supprime une image.**
*   `docker rmi mon_image:v1` : Supprime l'image.
*   `docker rmi $(docker images -q)` : Supprime toutes les images (attention).

---

### `docker-compose up`
**Démarre l'application.**
*   `docker-compose up -d` : En arrière-plan.
*   `docker-compose up --build` : Force la reconstruction des images.

### `docker-compose down`
**Arrête et supprime l'application.**
*   `docker-compose down` : Arrête et supprime conteneurs et réseaux.
*   `docker-compose down -v` : Supprime AUSSI les volumes (perte de données !).

### `docker-compose logs`
**Logs agrégés.**
*   `docker-compose logs -f` : Suit les logs de tous les services.
*   `docker-compose logs -f web` : Suit uniquement le service 'web'.

### `docker-compose ps`
**État des services.**
*   Liste les conteneurs du projet et leur état (Up/Exit).

### `docker-compose exec`
**Raccourci pour exec.**
*   `docker-compose exec web bash` : Entre dans le conteneur du service 'web'.