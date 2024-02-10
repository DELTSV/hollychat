# HollyChat

Twitter like flutter application

## Explication du concept

L’objectif de ce projet va être de développer une application mobile se basant sur une API existante.

Il s’agit d’une application de type “Twitter Like” (ou plutôt “X like” désormais..).

Un utilisateur peut :

- s’inscrire
- se connecter
- voir ses infos ou celles d’un autre utilisateur
- voir la liste des posts de l’app
- ajouter un post
- supprimer un post
- éditer un post
- ajouter un commentaire à un post
- supprimer un commentaire
- éditer un commentaire
- voir les posts d’un utilisateur

La notation sera expliquée ensuite mais comprenez qu’il s’agit d’aller bien sûr le plus loin possible dans l’intégration de cette API.

## Documentation API

Tout d’abord, n’hésitez pas à revenir vers moi pour tout comportement qui vous paraîtrait étrange au niveau de l’API.

J’utilise pour celle-ci un outil “no-code” pratique mais il est possible qu’il y ait encore quelques coquilles improbables que je réparerai alors sans problème.

La documentation de l’API, au format Swagger, peut se trouver ici : [https://x8ki-letl-twmt.n7.xano.io/api:xbcc5VEi](https://xoc1-kd2t-7p9b.n7c.xano.io/api:xbcc5VEi)

Normalement, **le format Swagger est largement suffisant pour comprendre l’API.**

Je me permet de re-préciser ici, à l’écrit, le fonctionnement de chaque route si nécessaire lorsque le Swagger n’est pas assez clair.

URL de base de l’API : https://xoc1-kd2t-7p9b.n7c.xano.io/api:xbcc5VEi

Routes + explications supplémentaires si nécessaires :

- **POST** **/auth/singnup**
    - email unique dans toute la BDD
    - name unique dans toute la BDD
    - password d’un minimum de 8 caractères
    - le token généré est valide pour 24 heures (86.400 secondes)
- **POST** **/auth/login**
    - le token généré est valide pour 24 heures (86.400 secondes)
- **GET /auth/me**
    - voir doc swagger
- **GET /user/{id}**
    - récupère les données publiques d’un utilisateur (sans l’email en fait)
- **GET /user/{id}/posts**
    - récupère les posts de l’utilisateur {id} de manière paginée
    - l’utilisateur n’a pas besoin d’être connecté
- **GET /post**
    - liste la totalité des posts de la BDD de manière **paginée**
        - page = la page courrante
        - per_page = le nombre d’item par page
    - l’utilisateur n’a pas besoin d’être connecté pour voir les posts
    - si vous ne voulez pas gérer la pagination, vous pouvez mettre un “per_page” énorme, mais le top est bien sûr de gérer la pagination
    - vous trouverez le nombre de commentaires pour chaque post dans l’objet JSON
- **GET** **/post/{id}**
    - récupère un post via son id
    - Vous récupèrez grâce à cette route le détail du post mais surtout tous ses commentaires associés
- **PATCH /post/{id}**
    - modifie le post souhaité
    - l’utilisateur doit être l’auteur du post pour faire cela (vérification via le token)
- **DELETE /post/{id}**
    - supprime le post souhaité
    - l’utilisateur doit être l’auteur du post pour faire cela (vérification via le token)
- **POST /post**
    - ajoute un post dans la BDD
    - l’utilisateur doit être connecté pour faire ça
    - un post doit forcément contenir du texte (`content`)
    - un post peut également avoir une image (optionnelle) au format `Base 64`
- **POST /comment**
    - ajoute un commentaire à un post ciblé via le champ `post_id`
    - l’utilisateur doit être connecté
- **PATCH /comment/{id}**
    - modifie le commentaire ciblé
- **DELETE /comment/{id}**
    - supprime le commentaire ciblé
    - l’utilisateur doit être l’auteur du commentaire pour faire cela (vérification via le token)

## Barème de notation

L’objectif du projet est clair : montrer que vous avez bien assimilé l’ensemble des concepts vus en cours.

Seront jugés à la fois le respect des fonctionnalités demandées ainsi que la qualité et l’architecture du code mais également l’expérience utilisateur associée.

Il faut imaginer que je regarderai l’application finale sous 2 regards :

- le regard d’un client : il s’en fiche de la techno ou de l’architecture, mais il faut que ça marche comme il a demandé.
- le regard d’un CTO : il regarde plutôt la qualité du code

Voici les différentes features évaluées et les critères d’évaluation associés :

### Inscription Connexion (5 points)

- Rendu (2 points)
    - Affichage formulaires
    - Bonne gestion de navigation associée
- Architecture (3 points)
    - Gestion d’état + séparation UI/logique
    - Tests d’intégrations
### Liste des posts (5 points)

- Rendu (2 points)
    - Affichage de la liste des posts
    - Pas nécessaire d’être connecté
    - Liste rafraîchissable via “Pull to refresh”
    - Liste paginée
- Architecture (3 points)
    - Gestion d’état + séparation UI/logique
    - Tests d’intégrations
    - Gestion de la pagination

### Détail d’un post + ajout Post (5 points)

- Rendu (2 points)
    - Affichage du détail au clique sur un post
    - Appel réseau spécifique pour avoir le détail d’un post à partir d’un ID
    - Possibilité de le modifier / supprimer si j’en suis l’auteur
    - Possibilité d’ajouter un post
    - Affichage des commentaires liés au post
- Architecture (3 points)
    - Gestion d’état + séparation UI/logique
    - Tests d’intégrations

### Commentaires (5 points)

- Rendu (2 points)
    - Affichage des commentaires d’un post
    - Possibilité de le modifier / supprimer si j’en suis l’auteur
    - Possibilité d’ajouter un commentaire
- Architecture (3 points)
    - Gestion d’état + séparation UI/logique
    - Tests d’intégrations

### Bonus / Malus

La notion de “Bonus/Malus” regroupe un ensemble de critères qui peuvent vous rajouter ou vous retirer des points.

Si un critère est noté [Bonus] alors celui-ci ne pourra que vous apporter des points supplémentaires

Si un critère est noté [Bonus/Malus] alors celui-ci pourrait aussi vous en faire perdre

⚠️ Le note finale est capée à 20/20.

Réfléchir aux bonus peut donc vous rattraper certains points mais ne pourra pas vous permettre d’avoir plus de 20/20.

- [Bonus/Malus] Qualité générale du code et de l’architecture de fichiers (+/-2 points)
- [Bonus] Affichage formulaire de connexion si token invalide (+2 points)
- [Bonus] Gestion des flavors (+1 points)