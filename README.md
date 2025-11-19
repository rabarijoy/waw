# Waw Showcase

Application Phoenix LiveView pour présenter et documenter la librairie Waw Components.

## Structure du projet

```
waw-showcase/
├── lib/
│   ├── waw_showcase/              # Logique métier de l'application
│   └── waw_showcase_web/          # Interface web
│       ├── live/
│       │   ├── home_live.ex                    # Page d'accueil
│       │   ├── component_detail_live.ex        # Page de détail d'un composant
│       │   └── components/                     # Pages de composants (à venir)
│       ├── components/
│       │   ├── layout.ex                       # Composant de layout
│       │   ├── sidebar.ex                     # Composant sidebar pour navigation
│       │   └── code_preview.ex                # Composant pour afficher code + preview
│       └── router.ex                          # Routes de l'application
├── assets/                        # Assets CSS/JS
├── mix.exs                        # Configuration Mix et dépendances
└── README.md
```

## Dépendances

Le projet utilise la librairie Waw Components locale, configurée dans `mix.exs` :

```elixir
{:waw, path: "/Volumes/PortableSSD/School/CNED/2A/Stage/waw-components"}
```

## Installation et démarrage

1. Installer les dépendances :
   ```bash
   mix setup
   ```

2. Démarrer le serveur Phoenix :
   ```bash
   mix phx.server
   ```
   Ou dans IEx :
   ```bash
   iex -S mix phx.server
   ```

3. Visiter [`localhost:4001`](http://localhost:4001) dans votre navigateur.

   **Note** : Le port par défaut est 4001. Vous pouvez le changer en définissant la variable d'environnement `PORT` :
   ```bash
   PORT=5000 mix phx.server
   ```

## Routes

- `/` - Page d'accueil (HomeLive)
- `/components/:component` - Page de détail d'un composant (ComponentDetailLive)

## Développement

Le projet est prêt pour le développement. Les fichiers suivants sont en place :

- **LiveViews** : Structure de base pour les pages principales
- **Composants** : Layout, Sidebar, et CodePreview prêts à être utilisés
- **Router** : Routes configurées pour LiveView

Les pages de composants individuels et l'intégration complète des composants Waw seront implémentées dans les prochaines étapes.

## Learn more

* Official website: https://www.phoenixframework.org/
* Guides: https://hexdocs.pm/phoenix/overview.html
* Docs: https://hexdocs.pm/phoenix
* Forum: https://elixirforum.com/c/phoenix-forum
* Source: https://github.com/phoenixframework/phoenix
