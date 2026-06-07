# ApexStore 🛒📱

**ApexStore** est une application mobile e-commerce multiplateforme moderne, performante et intuitive, conçue pour offrir une expérience utilisateur fluide et réactive pour l'achat de produits en ligne. 

Ce projet a été réalisé dans le cadre du **Projet de Fin de Formation (PFF)** pour l'obtention du diplôme en **Développement Digital (Option Applications Mobiles / Web)** à l'**ISTA NTIC** (OFPPT).

---

## 📑 Table des Matières
- [Caractéristiques Principales](#-caractéristiques-principales)
- [Architecture & Conception](#-architecture--conception)
- [Technologies & Packages Utilisés](#-technologies--packages-utilisés)
- [Structure du Projet](#-structure-du-projet)
- [Auteur & Encadrement](#-auteur--encadrement)

---

## 🚀 Caractéristiques Principales

### 🔹 Besoins Fonctionnels
* **Authentification :** Inscription, connexion sécurisée et déconnexion du profil.
* **Catalogue de Produits :** Affichage dynamique du catalogue global, recherche par mot-clé et filtrage par catégorie (Électronique, Vêtements, Bijoux...).
* **Gestion du Panier :** Ajout/suppression d'articles, modification des quantités et calcul automatique du montant total en temps réel.
* **Gestion des Favoris :** Ajout et suppression de produits "coup de cœur" avec persistance locale.

### 🔹 Besoins Non Fonctionnels
* **Performance :** Démarrage rapide (moins de 2 secondes) et mise en cache locale des images pour économiser la bande passante.
* **Fonctionnement Hybride (Offline) :** Grâce à SQLite, le panier et les favoris restent sauvegardés même si l'application est fermée ou hors ligne.
* **Interface Graphique :** Respect du Material Design avec des transitions fluides et une ergonomie épurée.

---

## 📐 Architecture & Conception

L'application implémente le design pattern **MVVM (Model-View-ViewModel)** pour assurer une séparation stricte des responsabilités :

* **Model :** Représente la structure des données pures (`Product`, `CartItem`) et gère la sérialisation/désérialisation JSON.
* **View :** Composée des widgets Flutter (UI) qui écoutent le *ViewModel* via `Provider`.
* **ViewModel :** Gère l'état de la vue, interagit avec les services et notifie l'interface via `notifyListeners()`.

> 🗄️ **Persistance Locale :** Une base de données relationnelle locale **SQLite** (`table_cart` et `table_favorites`) est intégrée pour synchroniser les choix de l'utilisateur.

---

## 🛠️ Technologies & Packages Utilisés

* **Framework :** Flutter (v3.x)
* **Langage :** Dart
* **Gestion d'état :** `provider` (Liaison MVVM)
* **Persistance locale :** `sqflite` & `path_provider`
* **Requêtes HTTP :** `http` (Consommation de l'API REST FakeStore API)

---

## 📁 Structure du Projet

L'arborescence du dossier `lib/` respecte le découpage architectural suivant :

```text
lib/
│
├── models/             # Modèles de données (Product, Cart, etc.)
│   ├── product_model.dart
│   └── cart_model.dart
│
├── viewmodels/         # Logique métier et gestion d'état (ChangeNotifier)
│   ├── product_viewmodel.dart
│   └── cart_viewmodel.dart
│
├── views/              # Interfaces graphiques (Widgets & Écrans)
│   ├── home_screen.dart
│   ├── product_detail_screen.dart
│   └── cart_screen.dart
│   └── widgets/        # Composants UI réutilisables
│
├── services/           # Connexions externes (API & Base de données)
│   ├── api_service.dart       # Appels vers FakeStore API
│   └── database_service.dart  # Opérations CRUD SQLite
│
└── main.dart           # Point d'entrée de l'application
