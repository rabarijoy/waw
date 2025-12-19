# Waw Showcase

Application de démonstration et documentation interactive pour la bibliothèque de composants UI **Waw**.

## 🎯 Objectif

Waw Showcase permet de :
- Explorer visuellement tous les composants disponibles dans la bibliothèque Waw
- Voir le code source de chaque composant
- Tester les composants dans différents contextes
- Inspecter les composants directement dans les pages via un clic droit
- Copier facilement le code des composants pour les réutiliser

## 🧭 Navigation rapide

### [Démarrer le projet](#démarrage-rapide)

### [Comprendre la structure du projet](#structure-de-lapplication)

### [Ajouter un composant dans les pages de démonstration](#1-ajouter-des-composants-dans-les-pages-de-démonstration)

### [Ajouter un composant dans la bibliothèque UI](#2-ajouter-des-composants-dans-la-bibliothèque-ui)

### [Comprendre l'extraction automatique](#extraction-automatique-des-composants)

### [Créer une nouvelle page de démonstration](#créer-une-nouvelle-page-de-démonstration)

### [Résoudre un problème](#dépannage)

## 🚀 Démarrage rapide

### Prérequis

- Elixir 1.15+
- Phoenix 1.8+
- Accès au dépôt Git `waw-components` (par défaut configuré dans `mix.exs` ligne 60)

**Note** : Si vous souhaitez utiliser une version locale de `waw-components` au lieu de la version Git :
1. Commentez la ligne 60 de `mix.exs` (la dépendance Git)
2. Décommentez et modifiez la ligne 59 avec le chemin vers votre version locale : `{:waw, path: "/chemin/vers/waw-components"}`
3. Exécutez `mix deps.get` pour mettre à jour les dépendances
4. Redémarrez le serveur (`mix phx.server`)

### Installation

```bash
# Installer les dépendances Elixir
mix deps.get

# Démarrer le serveur
mix phx.server
```

L'application sera accessible sur `http://localhost:4000`

## 📚 Structure de l'application

```
lib/
├── waw_showcase/              # Logique métier
│   ├── component_extractor.ex # Extraction automatique des composants depuis Waw
│   ├── component_cache.ex     # Cache des composants extraits
│   └── ui_config.ex           # Configuration statique des composants pour la bibliothèque UI
└── waw_showcase_web/          # Interface web
    ├── live/                  # LiveViews (pages)
    │   ├── home_live.ex       # Page d'accueil
    │   ├── components_live.ex # Liste des composants extraits
    │   └── ...
    └── components/            # Composants réutilisables
        └── layouts/          # Layouts et panneaux UI
```

## 🎨 Ajouter des composants à afficher

Il existe **deux façons principales** d'ajouter des composants à afficher dans Waw Showcase :

### 1. Ajouter des composants dans les pages de démonstration

Les pages de démonstration (`home_live.html.heex`, `vehicules_live.html.heex`, etc.) permettent d'afficher des exemples de composants dans un contexte réaliste dans la page "Demo".

#### Étapes pour ajouter un composant :

1. **Ouvrir le fichier template** de la page souhaitée (ex: `lib/waw_showcase_web/live/home_live.html.heex`)

2. **Ajouter le composant** avec l'attribut `data-component` :

```heex
<div data-component="waw_button">
  <.waw_button label="Mon bouton" />
</div>
```

**Important** : L'attribut `data-component` est essentiel pour :
- L'inspection du composant via clic droit
- L'extraction automatique des informations du composant
- L'affichage du code source dans la bibliothèque UI

Utilisez le tag exact du composant (ex: `"waw_button"`, `"waw_stat"`). Pour les composants Phoenix standards comme `<.input>`, utilisez `data-component="input"`.

#### Exemple complet :

```heex
<section class="space-y-6">
  <div data-component="waw_block_title">
    <.waw_block_title label="Ma nouvelle section" icon="star" />
  </div>
  
  <div class="grid grid-cols-1 gap-4">
    <div data-component="waw_stat">
      <.waw_stat value={42} title="Mon compteur" icon="chart-bar" />
    </div>
    
    <div data-component="waw_button">
      <.waw_button label="Action" />
    </div>
  </div>
</section>
```

### 2. Ajouter des composants dans la bibliothèque UI

La bibliothèque UI est une page séparée accessible via le bouton "UI" en haut à droite de la navigation (à côté du bouton "Demo"). Elle affiche les composants organisés par catégories. Pour ajouter un composant ici, vous devez le configurer dans `lib/waw_showcase/ui_config.ex`.

#### Étapes pour ajouter un composant :

1. **Ouvrir** `lib/waw_showcase/ui_config.ex`

2. **Trouver ou créer la catégorie** appropriée dans `@ui_components`

3. **Ajouter une nouvelle entrée** avec la structure suivante

4. **Redémarrer l'application** pour voir les changements

#### Structure de configuration

```elixir
@ui_components %{
  "Nom de la catégorie" => [
    %{
      sous_categorie: "Nom de la sous-catégorie",
      data_component: "waw_badge",    # Tag du composant (optionnel)
      module: "Waw.Badge",            # Module Elixir du composant
      groupe: "Affichage",            # Groupe pour les filtres (optionnel, voir section "Gestion des groupes")
      principal: %{
        nom: "Badge standard",
        code_source: """
<.waw_badge id="badge-1" label="Nouveau" color="info" />
"""
      },
      variantes: [
        %{
          nom: "Badge avec action",
          code_source: """
<.waw_badge id="badge-2" label="Closable" color="danger">
  <:action>
    <.waw_button_icon icon="cancel" />
  </:action>
</.waw_badge>
"""
        }
      ]
    }
  ]
}
```

#### Catégories disponibles

Les catégories actuellement configurées sont :
- **"Basiques"** : Composants de base (boutons, badges, tables, etc.)
- **"Texte et Nombres"** : Composants de texte et de formatage numérique
- **"Dates et heures"** : Composants de date et heure
- **"Cartes"** : Composants de type carte
- **"Icônes"** : Liste des icônes disponibles (générée automatiquement)

Vous pouvez créer de nouvelles catégories en ajoutant une nouvelle clé dans `@ui_components`.

## 🔍 Extraction automatique des composants

Waw Showcase peut **automatiquement extraire** les composants depuis la dépendance Waw via le module `ComponentExtractor`.

### Comment ça fonctionne

1. Au démarrage de l'application, `ComponentExtractor` parcourt le dossier `deps/waw/lib/waw`
2. Il extrait la documentation de chaque module
3. Il identifie les fonctions publiques qui sont des composants
4. Il extrait le nom, le code source (depuis la section `## Usage`), et le module
5. Les composants sont mis en cache dans ETS pour de meilleures performances

### Affichage des composants extraits

Les composants extraits automatiquement sont visibles sur la page `/components` et peuvent être recherchés.

## 📝 Bonnes pratiques

### 1. Organisation des variantes

Dans `ui_config.ex`, organisez les variantes du plus simple au plus complexe :
- Commencez par la variante de base dans `principal`
- Ajoutez les variantes avancées dans `variantes`

### 3. Code source dans les templates

Utilisez des backticks triples (`"""`) pour délimiter le code source dans `ui_config.ex`

### 4. Gestion des groupes

Pour les composants "Basiques", utilisez le champ `groupe` pour organiser les sous-catégories. Les groupes sont triés dans cet ordre :

1. **"Navigation"** - Composants de navigation (menus, breadcrumbs, etc.)
2. **"Actions"** - Boutons et actions utilisateur
3. **"Affichage"** - Badges, statuts, indicateurs visuels
4. **"Formulaires"** - Champs de formulaire et inputs
5. **"Listes"** - Listes et éléments de liste
6. **"Conteneurs"** - Accordions, modals, panneaux
7. **"Blocs"** - Blocs de contenu structurés
8. **"Tableaux"** - Tableaux et grilles de données
9. **"Navigation avancée"** - Pagination, steps, onglets
10. **"Recherche et filtres"** - Composants de recherche et filtrage
11. **"Cartes"** - Cartes et cartes de contenu
12. **"Autres"** - Composants qui ne rentrent dans aucune catégorie

Si vous ne spécifiez pas de `groupe`, le composant sera classé dans "Autres".

## 🐛 Dépannage

### Les composants n'apparaissent pas dans la bibliothèque UI

1. Vérifiez que vous avez ajouté l'entrée dans `ui_config.ex`
2. Redémarrez l'application (`mix phx.server`)
3. Vérifiez que le cache est à jour : `WawShowcase.UIConfigCache.preload_all()`

### L'inspection ne fonctionne pas

1. Vérifiez que l'attribut `data-component` est présent avec la valeur correcte (ex: `"waw_button"`)
2. Vérifiez que le LiveView utilise `use WawShowcaseWeb.Live.ComponentInspector`

### Les composants extraits ne sont pas à jour

1. Allez sur `/components` et cliquez sur "Actualiser"
2. Ou videz le cache manuellement dans IEx : `WawShowcase.Cache.delete(:waw_components)`

## 🆕 Créer une nouvelle page de démonstration

Pour créer une nouvelle page de démonstration :

1. **Créer le fichier LiveView** (`lib/waw_showcase_web/live/ma_page_live.ex`) avec `use WawShowcaseWeb.Live.ComponentInspector` pour activer l'inspection

2. **Créer le template** (`lib/waw_showcase_web/live/ma_page_live.html.heex`) en ajoutant vos composants avec `data-component` (voir section "Ajouter des composants dans les pages de démonstration")

3. **Ajouter la route** dans `lib/waw_showcase_web/router.ex` : `live "/ma-page", MaPageLive, :index`

4. **Ajouter le lien dans la navigation** (optionnel) dans `lib/waw_showcase_web/components/layouts.ex`


