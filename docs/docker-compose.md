# Référence complète — docker-compose.yml

## Table des matières

1. [Qu'est-ce que Docker Compose ?](#1-quest-ce-que-docker-compose-)
2. [Structure générale du fichier](#2-structure-générale-du-fichier)
3. [services — La racine de tout](#3-services--la-racine-de-tout)
4. [container_name — Nommer le conteneur](#4-container_name--nommer-le-conteneur)
5. [image — Utiliser une image existante](#5-image--utiliser-une-image-existante)
6. [build — Construire depuis un Dockerfile](#6-build--construire-depuis-un-dockerfile)
7. [ports — Ouvrir des ports](#7-ports--ouvrir-des-ports)
8. [volumes — Persister les données](#8-volumes--persister-les-données)
9. [environment — Variables de configuration](#9-environment--variables-de-configuration)
10. [volumes (niveau racine) — Volumes nommés](#10-volumes-niveau-racine--volumes-nommés)
11. [Exemple complet — One-shot](#11-exemple-complet--one-shot)
12. [Exemple complet — Persistant multi-services](#12-exemple-complet--persistant-multi-services)

---

## 1. Qu'est-ce que Docker Compose ?

Docker Compose permet de **définir et gérer plusieurs conteneurs** dans un seul fichier `docker-compose.yml`. Au lieu de taper de longues commandes `docker run` avec des dizaines d'options, vous décrivez tout votre projet dans ce fichier, puis lancez tout avec une seule commande.

```bash
docker-compose up -d       # Démarrer tout le projet en arrière-plan
docker-compose down        # Tout arrêter et supprimer
```

**Ce que Docker Compose gère pour vous :**
- La création et le nommage des conteneurs
- Le réseau entre les services (ils se voient par leur nom)
- La persistance des données via les volumes
- La configuration via les variables d'environnement

---

## 2. Structure générale du fichier

Le fichier `docker-compose.yml` est organisé en **blocs de haut niveau** :

```yaml
# docker-compose.yml

services:         # ← Obligatoire : liste de vos conteneurs
  mon_service:
    image: nginx

volumes:          # ← Optionnel : volumes nommés (pour bases de données, etc.)
  mes_donnees:
```

**L'indentation est critique en YAML.** Utilisez toujours des espaces (jamais des tabulations). Une mauvaise indentation provoque une erreur au démarrage.

---

## 3. services — La racine de tout

`services` est le bloc principal. Chaque entrée sous `services` définit un conteneur. Le nom que vous donnez à un service devient aussi son **nom d'hôte interne** : les autres services peuvent le joindre directement par ce nom.

```yaml
services:

  # "web" est le nom du service ET le nom d'hôte interne au réseau Docker
  web:
    image: nginx

  # "database" peut être joint par les autres services en utilisant "database" comme hôte
  database:
    image: mariadb:latest
```

**Règles de nommage :** utilisez des lettres minuscules, des chiffres, des underscores `_` ou des tirets `-`. Pas d'espaces.

**Combien de services ?** Autant que nécessaire. Un projet typique en a 1 à 3.

---

## 4. container_name — Nommer le conteneur

Par défaut, Docker Compose génère un nom de conteneur automatique (ex: `monprojet_web_1`). `container_name` vous permet de définir un nom fixe et lisible.

```yaml
services:
  web:
    container_name: mon_site_web
    image: nginx
```

```bash
# Avec container_name, vous utilisez le nom directement dans les commandes
docker logs mon_site_web
docker exec -it mon_site_web bash
docker stop mon_site_web
```

**Attention :** le `container_name` doit être **unique sur votre machine**. Si deux projets utilisent le même nom, il y a un conflit au démarrage.

**Combien de fois ?** Une fois par service.

---

## 5. image — Utiliser une image existante

`image` indique à Docker quelle image télécharger et utiliser directement, sans Dockerfile. C'est l'option idéale pour les services "tout faits" comme les bases de données ou les serveurs standards.

```yaml
# Syntaxe
image: <nom_image>
image: <nom_image>:<tag>
```

```yaml
services:
  database:
    image: mariadb:latest          # Dernière version de MariaDB

  cache:
    image: redis:7.2-alpine        # Redis version 7.2, image allégée

  proxy:
    image: nginx:1.25              # Nginx version précise
```

**`image` ou `build` ?**
- Utilisez `image` pour les services "off the shelf" : bases de données, serveurs web standards, outils connus
- Utilisez `build` pour vos propres applications avec un Dockerfile

**Combien de fois ?** Une fois par service qui utilise une image toute faite.

---

## 6. build — Construire depuis un Dockerfile

`build` indique à Docker Compose de **construire l'image** depuis un Dockerfile situé dans le dossier indiqué.

```yaml
# Syntaxe : indiquer le dossier qui contient le Dockerfile
build: ./mon_dossier
```

```yaml
services:
  # Le Dockerfile se trouve dans le dossier ./backend
  web:
    build: ./backend
    ports:
      - "8080:80"

  # Le Dockerfile se trouve dans le dossier courant (.)
  script:
    build: .
```

**Combien de fois ?** Une fois par service qui a son propre Dockerfile.

---

## 7. ports — Ouvrir des ports

`ports` mappe un port de **votre machine** vers un port à l'**intérieur du conteneur**. Sans ce mapping, le service est inaccessible depuis votre navigateur ou votre terminal.

```yaml
# Syntaxe : "PORT_HOTE:PORT_CONTENEUR"
# Toujours entre guillemets

ports:
  - "8080:80"
```

```yaml
services:
  web:
    image: nginx
    ports:
      - "8080:80"     # Votre navigateur → http://localhost:8080 → port 80 du conteneur
      - "8443:443"    # Votre navigateur → https://localhost:8443 → port 443 du conteneur
```

**Schéma de fonctionnement :**
```
Votre navigateur → localhost:8080 → Docker → conteneur:80
```

**Points importants :**
- Un port de votre machine ne peut être utilisé que par **un seul conteneur** à la fois
- Si le port est déjà utilisé sur votre machine, Docker retourne une erreur au démarrage
- Les services dans le même projet Docker Compose se voient directement **par leur nom et port interne**, sans passer par les ports de votre machine

**Combien de fois ?** Autant de lignes que de ports à exposer. Uniquement pour les services **persistants** — un one-shot n'expose généralement pas de ports.

---

## 8. volumes — Persister les données

`volumes` crée un lien entre un dossier de **votre machine** et un dossier **dans le conteneur**. Sans volume, toute donnée créée dans un conteneur **disparaît** quand il est supprimé.

```yaml
# Syntaxe : "DOSSIER_SUR_VOTRE_PC:DOSSIER_DANS_LE_CONTENEUR"
volumes:
  - ./dossier_local:/dossier_conteneur
```

**Deux usages courants :**

**Lier un dossier de votre PC** (bind mount) — pour partager des fichiers en temps réel :
```yaml
volumes:
  - ./src:/var/www/html         # Vos fichiers HTML accessibles dans le conteneur
  - ./output:/app/output        # Récupérer les fichiers générés par un one-shot
  - ./config/nginx.conf:/etc/nginx/nginx.conf   # Partager un fichier de config
```

**Volume nommé** — pour persister les données d'une base de données :
```yaml
volumes:
  - mes_donnees_mysql:/var/lib/mysql    # Docker gère l'emplacement sur le disque
```

```yaml
services:
  web:
    image: nginx
    volumes:
      - ./html:/usr/share/nginx/html    # Vos fichiers HTML dans le conteneur

  database:
    image: mariadb:latest
    volumes:
      - db_data:/var/lib/mysql          # Volume nommé pour ne pas perdre la base

# Les volumes nommés doivent être déclarés ici (voir section 10)
volumes:
  db_data:
```

**Bind mount vs Volume nommé :**

| | Bind mount (`./dossier:/dest`) | Volume nommé (`nom:/dest`) |
| :--- | :--- | :--- |
| Emplacement | Dossier que vous choisissez sur votre PC | Géré automatiquement par Docker |
| Usage typique | Code source, fichiers de config, output | Données de bases de données |
| Accès facile sur votre PC | ✅ Oui | ❌ Non (chemin interne à Docker) |

**Combien de fois ?** Autant que nécessaire selon vos besoins.

---

## 9. environment — Variables de configuration

`environment` injecte des variables dans le conteneur au moment de son démarrage. C'est le moyen standard de configurer un service : mots de passe, nom de la base de données, mode de fonctionnement...

```yaml
# Syntaxe
environment:
  - NOM_VARIABLE=valeur
  - AUTRE_VARIABLE=autre_valeur
```

```yaml
services:
  database:
    image: mariadb:latest
    environment:
      - MARIADB_ROOT_PASSWORD=mon_mot_de_passe_root
      - MARIADB_DATABASE=ma_base
      - MARIADB_USER=mon_utilisateur
      - MARIADB_PASSWORD=mon_mot_de_passe_user

  app:
    build: ./backend
    environment:
      - APP_ENV=production
      - DB_HOST=database        # "database" = le nom du service MariaDB ci-dessus
      - DB_PORT=3306
      - DB_NAME=ma_base
```

**Comment un service connaît l'adresse d'un autre ?**
Dans Docker Compose, les services se voient par leur **nom de service**. Ici, `app` peut joindre `database` en utilisant simplement `database` comme hôte — Docker s'occupe de la résolution DNS interne.

**Combien de fois ?** Le bloc `environment` apparaît une fois par service qui en a besoin. Le nombre de variables à l'intérieur est illimité.

---

## 10. volumes (niveau racine) — Volumes nommés

Quand vous utilisez un **volume nommé** dans un service (ex: `db_data:/var/lib/mysql`), vous devez le **déclarer** une seconde fois au niveau racine du fichier, en dehors du bloc `services`.

```yaml
services:
  database:
    image: mariadb:latest
    volumes:
      - db_data:/var/lib/mysql    # ← Volume nommé utilisé ici

  cache:
    image: redis
    volumes:
      - redis_data:/data          # ← Autre volume nommé

# Déclaration obligatoire en bas du fichier
volumes:
  db_data:        # Juste le nom suffit, Docker gère le reste
  redis_data:
```

**Si vous oubliez cette déclaration**, Docker Compose retourne une erreur au démarrage.

**Les volumes nommés survivent à `docker-compose down`**, ce qui est le but. Pour les supprimer en même temps que les conteneurs, utilisez `docker-compose down -v` — **attention, cela efface toutes les données** de la base de données.

---

## 11. Exemple complet — One-shot

```yaml
# docker-compose.yml pour une tâche one-shot
# Usage : docker-compose up  (sans -d pour voir le résultat en direct)

services:

  generateur:
    container_name: mon_generateur

    # On construit l'image depuis le Dockerfile dans le dossier courant
    build: .

    # INDISPENSABLE : sans volume, le fichier généré disparaît avec le conteneur
    volumes:
      - ./output:/app/output

    # Variables de configuration du script (décommenter si besoin)
    # environment:
    #   - MA_VARIABLE=ma_valeur
```

---

## 12. Exemple complet — Persistant multi-services

```yaml
# docker-compose.yml pour un site web + base de données

services:

  # ─── Service 1 : Serveur Web ───────────────────────────────────────────────
  web:
    container_name: mon_site

    # Le Dockerfile se trouve dans ./web
    build: ./web

    # Accès depuis votre navigateur : http://localhost:8080
    ports:
      - "8080:80"

    # Les fichiers HTML viennent de votre PC (modifiables sans rebuild)
    volumes:
      - ./web/html:/usr/share/nginx/html

    # Variables de config pour se connecter à la base de données
    environment:
      - DB_HOST=database      # "database" = le nom du service ci-dessous
      - DB_NAME=ma_base

  # ─── Service 2 : Base de données ──────────────────────────────────────────
  database:
    container_name: ma_base_de_donnees

    # Image officielle MariaDB, pas besoin de Dockerfile
    image: mariadb:latest

    # Configuration de la base (utilisateur, mot de passe, nom)
    environment:
      - MARIADB_ROOT_PASSWORD=root_secret
      - MARIADB_DATABASE=ma_base
      - MARIADB_USER=mon_user
      - MARIADB_PASSWORD=user_secret

    # Volume nommé : les données persistent même après docker-compose down
    volumes:
      - db_data:/var/lib/mysql

# Déclaration obligatoire du volume nommé utilisé ci-dessus
volumes:
  db_data:
```