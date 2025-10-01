# Projet Docker J3 - Stack Production-Ready



## Pourquoi utiliser internal: true pour le network database ?



## Que se passe-t-il si on supprime le volume postgres_data ?

On perd toutes les données crées en base de donnée.

## Où est stocké le secret dans le conteneur ?

Dans le conteneur le secret et stocké dans le dossier **run/secrets** dans le fichier **db_password**