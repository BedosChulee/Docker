# Projet Docker J3 - Stack Production-Ready



## Pourquoi utiliser internal: true pour le network database ?

Pour ne pas exposer la bdd à l'extérieur du container. Comme cela un utilisateur externe ne peux pas avoir accès à la bdd à partir d'internet. Seul ceux qui ont accès au container peuvent avoir accès à la bdd.


## Que se passe-t-il si on supprime le volume postgres_data ?

On perd toutes les données crées en base de donnée.

## Où est stocké le secret dans le conteneur ?

Dans le conteneur le secret et stocké dans le dossier **run/secrets** dans le fichier **db_password**

## Pourquoi utiliser pg_isready dans l'entrypoint ?

Parce que pg_isready permet de vérifier que PostgreSQL est démarré et prêt à accepter des connexions.
Sans ça, le backend pourrait essayer de se connecter trop tôt et donc provoquer une erreur de connexion.

## Quelle est la différence entre les targets production et development ?

    •	development : image plus lourde, avec outils de debug, hot-reload, dépendances de développement → idéale pour coder/tester.

	•	production : image optimisée, sans dépendances inutiles, fichiers précompilés, configuration stricte → destinée à être déployée.

## Comment Rails lit-il le mot de passe de la base de données ?

Rails va chercher les infos dans config/database.yml.

Donc Rails lit le mot de passe via une variable d’environnement que tu lui passes dans le container (DATABASE_PASSWORD, POSTGRES_PASSWORD, etc.).
