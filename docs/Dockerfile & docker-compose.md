# Dockerfile & docker-compose — Par où commencer ?

Ce fichier est votre **point d'entrée**. Il vous aide à identifier quelle template ou quel exemple correspond à votre besoin, avant de plonger dans la documentation technique.

---

## C'est quoi un conteneur "one-shot" ?

Un conteneur **one-shot** est un conteneur qui **s'exécute une fois, fait son travail, puis s'arrête proprement**.

Il n'écoute aucun port, ne reste pas "en vie" après son exécution.

**Exemples typiques :**
- Générer un fichier (rapport, export CSV, mot de passe...)
- Lancer un script de sauvegarde
- Exécuter une migration de données
- Faire tourner une suite de tests

**Vous êtes dans ce cas si :**
- Votre script a un début et une fin
- Vous voulez récupérer un fichier résultat sur votre machine
- Vous n'avez pas besoin d'un service qui "tourne" en arrière-plan

→ Allez dans `template/oneshot/` ou regardez l'exemple dans `example/oneshot/`

---

## C'est quoi un conteneur "persistant" ?

Un conteneur **persistant** est un conteneur qui **tourne en continu** et attend des connexions ou des requêtes. Il ne s'arrête que si vous le stoppez manuellement.

**Exemples typiques :**
- Un serveur Web (Apache, Nginx, Node.js...)
- Une base de données (MySQL, MariaDB, PostgreSQL...)
- Une API REST
- Un bot, un service de traitement en continu...

**Vous êtes dans ce cas si :**
- Votre application doit rester disponible
- Elle écoute sur un port (ex: port 80 pour HTTP, port 3306 pour MySQL)
- Vous avez potentiellement plusieurs services qui communiquent entre eux

→ Allez dans `template/persistant/` ou regardez l'exemple dans `example/persistant/`

---

## Choisir rapidement

| Ma situation | Où aller |
| :--- | :--- |
| Je veux exécuter un script une seule fois | `template/oneshot/` |
| Je veux un serveur web ou une API | `template/persistant/` |
| Je veux voir un exemple de script one-shot qui fonctionne | `example/oneshot/` |
| Je veux voir un site web + base de données qui fonctionnent | `example/persistant/` |
| Je veux comprendre chaque instruction d'un Dockerfile | [`docs/Dockerfile.md`](./Dockerfile.md) |
| Je veux comprendre chaque clé d'un docker-compose.yml | [`docs/docker-compose.md`](./docker-compose.md) |
| Je veux la liste des commandes Docker | [`README.md`](../README.md) |

---

## Structure du projet pour référence

```
.
├── docs/
│   ├── Dockerfile & docker-compose.md   ← Vous êtes ici
│   ├── Dockerfile.md                    ← Référence complète du Dockerfile
│   └── docker-compose.md                ← Référence complète du docker-compose
├── example/
│   ├── oneshot/                         ← Générateur de mot de passe (fonctionnel)
│   └── persistant/                      ← Site Apache + MySQL (fonctionnel)
├── template/
│   ├── oneshot/                         ← Base propre à copier pour un script
│   └── persistant/                      ← Base propre à copier pour un service
└── README.md                            ← Cheatsheet des commandes Docker
```