# Référence complète — Dockerfile

## Table des matières

1. [Qu'est-ce qu'un Dockerfile ?](#1-quest-ce-quun-dockerfile-)
2. [FROM — Choisir l'image de base](#2-from--choisir-limage-de-base)
3. [WORKDIR — Définir le répertoire de travail](#3-workdir--définir-le-répertoire-de-travail)
4. [COPY — Copier des fichiers dans l'image](#4-copy--copier-des-fichiers-dans-limage)
5. [RUN — Exécuter des commandes à la construction](#5-run--exécuter-des-commandes-à-la-construction)
6. [ENTRYPOINT — La commande de démarrage](#6-entrypoint--la-commande-de-démarrage)
7. [CMD — Arguments par défaut](#7-cmd--arguments-par-défaut)
8. [ENTRYPOINT vs CMD — La combinaison](#8-entrypoint-vs-cmd--la-combinaison)
9. [Ordre recommandé des instructions](#9-ordre-recommandé-des-instructions)

---

## 1. Qu'est-ce qu'un Dockerfile ?

Un Dockerfile est un fichier texte qui contient **une suite d'instructions** pour construire une image Docker. Docker lit ce fichier de haut en bas et exécute chaque instruction dans l'ordre.

Chaque instruction crée une **couche (layer)** dans l'image. Docker met ces couches en cache : si une instruction n'a pas changé depuis le dernier build, Docker réutilise la couche existante au lieu de la reconstruire. C'est pourquoi **l'ordre des instructions a son importance** : placez ce qui change rarement en haut, et ce qui change souvent en bas.

```dockerfile
# Ceci est un commentaire — Docker ignore les lignes commençant par #
# Nom du fichier : toujours "Dockerfile" (sans extension)
```

---

## 2. FROM — Choisir l'image de base

**Obligatoire. Doit être la première instruction du fichier.**

`FROM` définit l'image de départ sur laquelle votre image sera construite. Pensez-y comme un système d'exploitation minimal déjà prêt, sur lequel vous allez ajouter vos outils et votre code.

```dockerfile
# Syntaxe
FROM <image>
FROM <image>:<tag>
```

```dockerfile
# Exemples courants
FROM ubuntu:24.04          # Linux Ubuntu, polyvalent
FROM debian:bookworm-slim  # Debian allégé, très courant
FROM python:3.11-slim      # Python déjà installé, sur base Debian
FROM node:20-alpine        # Node.js sur Alpine (très léger)
FROM httpd:2.4             # Serveur Apache prêt à l'emploi
```

**À propos des tags :**

| Tag | Signification |
| :--- | :--- |
| `latest` | Dernière version disponible |
| `24.04` | Version précise et stable (recommandé) |
| `slim` | Version allégée, sans outils superflus |
| `alpine` | Version ultra-légère (~5MB) |
| `buster`, `bookworm` | Nom de version Debian |

**Combien de fois ?** Une seule fois, toujours en première ligne.

---

## 3. WORKDIR — Définir le répertoire de travail

`WORKDIR` définit le **dossier courant** à l'intérieur du conteneur pour toutes les instructions qui suivent (`RUN`, `COPY`, `ENTRYPOINT`). C'est l'équivalent d'un `cd` : après cette instruction, vous "êtes" dans ce dossier.

```dockerfile
# Syntaxe
WORKDIR /chemin/absolu
```

```dockerfile
# Exemple
WORKDIR /app

# Toutes les instructions suivantes s'exécutent dans /app
COPY script.sh .          # Copie dans /app/script.sh
RUN chmod +x script.sh    # Exécute chmod dans /app
```

**Points importants :**
- Si le dossier n'existe pas, Docker le **crée automatiquement**
- Utilisez toujours un chemin absolu (commençant par `/`)
- Vous pouvez changer de `WORKDIR` **plusieurs fois** dans le même Dockerfile
- Sans `WORKDIR`, vous travaillez à la racine `/` — c'est une mauvaise pratique

**Combien de fois ?** Autant que nécessaire. En pratique, 1 à 2 fois suffit.

---

## 4. COPY — Copier des fichiers dans l'image

`COPY` copie des fichiers ou des dossiers depuis **votre machine** vers l'image en cours de construction.

```dockerfile
# Syntaxe
COPY <source_sur_votre_pc> <destination_dans_image>
```

```dockerfile
# Copier un fichier unique dans le WORKDIR courant
COPY script.sh .                    # "." = dans le WORKDIR courant

# Copier un fichier vers un chemin précis
COPY config.json /app/config.json

# Copier un dossier entier
COPY ./src /app/src                 # Tout le contenu de ./src dans /app/src
```

**Le point `.` comme destination** signifie "dans le WORKDIR courant". Si votre WORKDIR est `/app`, alors `COPY script.sh .` copie le fichier dans `/app/script.sh`.

**Bonne pratique :** copiez d'abord les fichiers de dépendances (qui changent rarement), puis votre code source (qui change souvent). Cela exploite le cache de Docker efficacement.

```dockerfile
WORKDIR /app

# Étape 1 : les dépendances changent rarement → bien mis en cache
COPY package.json .
RUN npm install

# Étape 2 : le code source change souvent → placé après
COPY ./src ./src
```

**Combien de fois ?** Autant que nécessaire. En pratique, 1 à 3 fois.

---

## 5. RUN — Exécuter des commandes à la construction

`RUN` exécute une commande **au moment de la construction de l'image**, pas au démarrage du conteneur. Utilisez-le pour installer des logiciels, rendre des scripts exécutables, créer des dossiers...

```dockerfile
# Syntaxe
RUN <commande>
```

```dockerfile
# Installer des paquets sur Ubuntu/Debian
RUN apt-get update && apt-get install -y curl git python3

# Rendre un script exécutable
RUN chmod +x script.sh

# Créer un dossier
RUN mkdir -p /app/output

# Installer des dépendances Python
RUN pip install -r requirements.txt

# Installer des dépendances Node.js
RUN npm install
```

**Règle importante — `update` et `install` toujours sur la même ligne :**
Docker met les couches en cache. Si vous séparez `apt-get update` et `apt-get install` en deux `RUN` distincts, Docker peut réutiliser le cache du `update` et installer des versions périmées.

```dockerfile
# ✅ Correct : update et install sur la même ligne
RUN apt-get update && apt-get install -y curl python3

# ❌ À éviter : Docker peut ignorer le update au prochain build
RUN apt-get update
RUN apt-get install -y curl python3
```

**Fusionner plusieurs commandes liées avec `&&` et `\` :**

```dockerfile
RUN apt-get update \
    && apt-get install -y \
        curl \
        git \
        python3 \
    && apt-get clean
```

**Combien de fois ?** Autant que nécessaire. Essayez de regrouper les commandes liées dans le même `RUN` pour garder un Dockerfile propre.

---

## 6. ENTRYPOINT — La commande de démarrage

`ENTRYPOINT` définit le **processus principal** qui sera lancé quand le conteneur démarre. C'est ce processus qui maintient le conteneur en vie : si `ENTRYPOINT` se termine, le conteneur s'arrête.

```dockerfile
# Syntaxe recommandée (tableau JSON)
ENTRYPOINT ["executable", "arg1", "arg2"]
```

```dockerfile
# One-shot : exécuter un script puis s'arrêter
ENTRYPOINT ["./script.sh"]

# Application Python
ENTRYPOINT ["python", "app.py"]

# Application Node.js
ENTRYPOINT ["node", "index.js"]

# Serveur Apache — doit rester en avant-plan
ENTRYPOINT ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]

# Serveur Nginx — doit rester en avant-plan
ENTRYPOINT ["nginx", "-g", "daemon off;"]
```

**Pourquoi `FOREGROUND` pour Apache et `daemon off` pour Nginx ?**
Docker s'attend à ce que le processus reste **en premier plan**. Ces serveurs se lancent en arrière-plan par défaut (en tant que "daemon"), ce qui ferait croire à Docker que le processus est terminé — et le conteneur s'arrêterait immédiatement. Ces options les forcent à rester visibles au premier plan.

**Combien de fois ?** Une seule fois, toujours en dernière ligne. S'il y en a plusieurs, seul le dernier est pris en compte.

---

## 7. CMD — Arguments par défaut

`CMD` fournit des **arguments par défaut** à `ENTRYPOINT`. Contrairement à `ENTRYPOINT`, ces arguments peuvent être **remplacés** au lancement du conteneur sans avoir à reconstruire l'image.

```dockerfile
# Syntaxe recommandée (tableau JSON)
CMD ["arg1", "arg2"]
```

```dockerfile
# CMD seul, sans ENTRYPOINT : lance bash par défaut
CMD ["bash"]

# CMD avec ENTRYPOINT : fournit les arguments par défaut
ENTRYPOINT ["python", "app.py"]
CMD ["--mode", "production"]    # → exécute : python app.py --mode production
```

**Combien de fois ?** Une seule fois. S'il y en a plusieurs, seul le dernier est pris en compte.

---

## 8. ENTRYPOINT vs CMD — La combinaison

| Situation | Quoi utiliser |
| :--- | :--- |
| Commande fixe que personne ne modifie | `ENTRYPOINT` seul |
| Commande avec des arguments qu'on peut changer au lancement | `ENTRYPOINT` + `CMD` |
| Commande entièrement remplaçable au lancement | `CMD` seul |

**En pratique pour un débutant :** utilisez `ENTRYPOINT` seul dans la grande majorité des cas. `CMD` devient utile quand vous voulez rendre votre conteneur configurable sans le reconstruire.

```dockerfile
# Exemple : application Python avec mode configurable
ENTRYPOINT ["python", "app.py"]
CMD ["--mode", "production"]

# Lancement normal                 → python app.py --mode production
# docker run mon_image --mode dev  → python app.py --mode dev
```

---

## 9. Ordre recommandé des instructions

Voici l'ordre standard d'un Dockerfile bien écrit. Cet ordre **optimise le cache** : ce qui change rarement est en haut, ce qui change souvent est en bas.

```dockerfile
# 1. Toujours en premier : l'image de base
FROM ubuntu:24.04

# 2. Le répertoire de travail
WORKDIR /app

# 3. Installation des dépendances système (change rarement)
RUN apt-get update && apt-get install -y python3 pip \
    && apt-get clean

# 4. Copie et installation des dépendances du projet (change peu)
COPY requirements.txt .
RUN pip install -r requirements.txt

# 5. Copie du code source (change souvent → le plus bas possible)
COPY . .

# 6. Préparation finale (chmod, etc.)
RUN chmod +x script.sh

# 7. Toujours en dernier : la commande de démarrage
ENTRYPOINT ["python", "app.py"]
```