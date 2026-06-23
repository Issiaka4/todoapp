# 📝 Todo Simple - Architecture en 3 Couches

Une application Flutter de gestion de tâches (Todo List) simple et robuste, intégrant **Firebase Authentication** et **Cloud Firestore**. Le projet est structuré selon une architecture en 3 couches (Présentation, Domaine, Données) pour garantir sa maintenabilité et son évolutivité.

## 🚀 Fonctionnalités
* 🔐 **Authentification** : Inscription et connexion par Email / Mot de passe via Firebase Auth.
* 📋 **Gestion des tâches** : Ajout, modification du statut (complété/en cours) et suppression en temps réel avec Firestore.
* 🛡️ **Sécurité** : Les tâches sont filtrées par utilisateur (`userId`) ; vous ne voyez que vos propres tâches.

---

## 📂 Structure du Projet

Le code est découpé de la manière suivante dans le dossier `lib/` :

```text
lib/
│
├── data/                  # Couche Données (Services, API, Firebase)
│   ├── auth_service.dart      -> Gestion de la connexion/inscription
│   └── task_repository.dart   -> Requêtes CRUD Firestore
│
├── domain/                # Couche Domaine (Modèles et logique métier pure)
│
├── presentation/          # Couche Présentation (Interface utilisateur)
│   ├── auth_page.dart         -> Écran de login / registre
│   └── home_page.dart         -> Écran de la liste des tâches
│
└── main.dart              # Point d'entrée de l'application
