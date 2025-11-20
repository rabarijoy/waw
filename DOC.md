# Documentation complète des composants Waw Components

Ce document liste tous les composants disponibles dans la bibliothèque Waw Components avec leurs descriptions, attributs, slots et exemples d'utilisation.

## Table des matières

1. [Composants de base](#composants-de-base)
2. [Composants de structure](#composants-de-structure)
3. [Composants de formulaire](#composants-de-formulaire)
4. [Composants de données](#composants-de-données)
5. [Composants de navigation](#composants-de-navigation)
6. [Composants LiveView](#composants-liveview)
7. [Layouts](#layouts)
8. [Templates](#templates)
9. [Pages](#pages)
10. [Styleguide](#styleguide)
11. [Composants de formatage](#composants-de-formatage)

---

## Composants de base

### waw_accordion

**Module:** `Waw.Accordion`

**Description:** Afficher un accordion.

**Description détaillée:** Afficher un accordion.

**Import:**
```elixir
import Waw.Delegates  # ou use Waw
```

**Attributs:**

| Attribut | Type | Requis | Défaut | Valeurs | Description |
|----------|------|--------|--------|---------|-------------|
| `id` | `string` | Oui | - | - | - |
| `has_group` | `boolean` | Non | false | - | - |
| `expanded` | `boolean` | Non | false | - | - |
| `selected` | `boolean` | Non | false | - | - |
| `head_icon` | `string` | Non | exclamationmark-circle-fill | - | - |
| `title` | `string` | Non | Vehicule | - | - |
| `count` | `integer` | Non | 0 | - | - |

**Slots:**

- `:inner_block`

**Exemple d'utilisation:**
```heex
<.waw_accordion count={12} id="accordion-single-normal">
      ...
    </.waw_accordion>
```

---

### waw_badge

**Module:** `Waw.Badge`

**Description:** Afficher badge

**Import:**
```elixir
import Waw.Delegates  # ou use Waw
```

---

### waw_button

**Module:** `Waw.Button`

**Description:** Afficher le bouton utilisé dans les applications Tag-IP.

**Description détaillée:** Lister les types de bouton utilisés dans les applications Tag-IP.

**Import:**
```elixir
import Waw.Delegates  # ou use Waw
```

**Attributs:**

| Attribut | Type | Requis | Défaut | Valeurs | Description |
|----------|------|--------|--------|---------|-------------|
| `label` | `string` | Non | - | - | - |
| `icon` | `string` | Non | - | Waw.Icons.icon_list( | Icon name |
| `icon_position` | `string` | Non | left | ~w(left right | Icon position compared to the text |
| `type` | `string` | Non | button | ~w(button submit cancel | - |
| `size` | `string` | Non | md | ~w(xs sm md lg | The size of the component. |
| `full_width` | `boolean` | Non | false | - | If true, the component will take up the full width of its container. |
| `state` | `string` | Non | default | ~w(default checked unchecked | The state to use. |
| `disabled` | `boolean` | Non | false | - | The disabled button of component. |
| `toggleable` | `boolean` | Non | false | - | The toggleable button of component. |

**Exemple d'utilisation:**
```heex
<.waw_button label="Aujourd'hui" size="md" icon="calendar" icon_position="right" />
    <.waw_button label="Envoyer" size="md" type="submit" />
```

---

### waw_button_group

**Module:** `Waw.ButtonGroup`

**Description:** Afficher un groupe de boutons.

**Import:**
```elixir
import Waw.Delegates  # ou use Waw
```

---

### waw_card

**Module:** `Waw.Card`

**Description:** Afficher le card.

**Description détaillée:** Afficher le card.

**Import:**
```elixir
import Waw.Delegates  # ou use Waw
```

**Attributs:**

| Attribut | Type | Requis | Défaut | Valeurs | Description |
|----------|------|--------|--------|---------|-------------|
| `title_icon` | `string` | Non | map | - | Use name of the icon of Tag-IP for title card content. |
| `info_icon` | `string` | Non | info-circle | - | Icon for informations. |
| `title` | `string` | Non | itest | - | Title of card component. |
| `tooltip_description` | `string` | Non | Aucune description disponible | - | Tooltip for plus informations. |
| `state` | `string` | Non | normal | ["normal" | State of the component between `normal` and `selected`.  |
| `label` | `string` | Non | - | - | - |
| `value` | `string` | Non | - | - | - |

**Exemple d'utilisation:**
```heex
<.waw_card title="Driver Score Card Synthesis" tooltip_description="Sous forme d'une carte, présente une présentation graphique des trajectoires des véhicules.">
      <:section>
        <.waw_time_section label="Dernier Maj" value="12:30:05" />
        <.waw_date_section label="Dernier CR disponible" value="Aujourd'hui" />
        <.waw_date_section label="1er CR disponible" value="Aujourd'hui" />
      </:section>
    </.waw_card>
```

---

### waw_button_icon

**Module:** `Waw.Clickable`

**Description:** Afficher un text clickable et une icone clickable.

**Import:**
```elixir
import Waw.Delegates  # ou use Waw
```

---

### waw_contenteditable

**Module:** `Waw.Contenteditable`

**Description:** Afficher un texte éditable.

**Import:**
```elixir
import Waw.Delegates  # ou use Waw
```

---

### waw_fuel_card

**Module:** `Waw.FuelCard`

**Description:** Afficher une modele de carte pour le volume de carburant.

**Description détaillée:** Carte pour le volume de carburant

**Import:**
```elixir
import Waw.Delegates  # ou use Waw
```

**Attributs:**

| Attribut | Type | Requis | Défaut | Valeurs | Description |
|----------|------|--------|--------|---------|-------------|
| `title` | `string` | Non | - | - | - |
| `number` | `string` | Non | - | - | - |
| `value` | `string` | Non | - | - | - |

**Exemple d'utilisation:**
```heex
<.waw_fuel_card
      title="Consommation totale de carburant de la flotte"
      number="1510"
      value="35"
    />
```

---

### waw_icon

**Module:** `Waw.Icons`

**Description:** Liste des icônes utilisées par les applications Tag-IP.

**Description détaillée:** Lister les icônes utilisés dans les applications Tag-IP.

**Import:**
```elixir
import Waw.Delegates  # ou use Waw
```

---

### waw_link_text

**Module:** `Waw.Link`

**Description:** Afficher un lien.

**Description détaillée:** Lien texte avec type d'états.

**Import:**
```elixir
import Waw.Delegates  # ou use Waw
```

**Attributs:**

| Attribut | Type | Requis | Défaut | Valeurs | Description |
|----------|------|--------|--------|---------|-------------|
| `label` | `string` | Non | - | - | Étiquette du composant. |
| `size` | `string` | Non | sm | ~w(xs sm md lg | La taille du composant. |
| `state` | `string` | Non | default | ~w(default checked unchecked | The state to use. |
| `disabled` | `boolean` | Non | false | - | The disabled button of component. |

**Exemple d'utilisation:**
```heex
<.waw_link_text label="3 derniers jours" size="sm" state="unchecked"/>
```

---

### waw_link_icon

**Module:** `Waw.Link`

**Description:** Afficher un lien.

**Description détaillée:** Lien icône avec type d'états.

**Import:**
```elixir
import Waw.Delegates  # ou use Waw
```

**Attributs:**

| Attribut | Type | Requis | Défaut | Valeurs | Description |
|----------|------|--------|--------|---------|-------------|
| `label` | `string` | Non | - | - | Étiquette du composant. |
| `size` | `string` | Non | sm | ~w(xs sm md lg | La taille du composant. |
| `state` | `string` | Non | default | ~w(default checked unchecked | The state to use. |
| `disabled` | `boolean` | Non | false | - | The disabled button of component. |

**Exemple d'utilisation:**
```heex
<.waw_link_icon size="sm" state="unchecked" icon="home"/>
```

---

### waw_loading

**Module:** `Waw.Loading`

**Description:** Loading

**Description détaillée:** Loading lors d'un chargement de page.

**Import:**
```elixir
import Waw.Delegates  # ou use Waw
```

**Exemple d'utilisation:**
```heex
<.waw_loading />
```

---

### waw_modal

**Module:** `Waw.Modal`

**Description:** Component modal

**Import:**
```elixir
import Waw.Delegates  # ou use Waw
```

---

### waw_name

**Module:** `Waw.TrackableName`

**Description:** Afficher un trackable.

**Description détaillée:** Afficher un trackable.

**Import:**
```elixir
import Waw.Delegates  # ou use Waw
```

**Attributs:**

| Attribut | Type | Requis | Défaut | Valeurs | Description |
|----------|------|--------|--------|---------|-------------|
| `value` | `any` | Oui | - | - | Informations |
| `size` | `string` | Non | sm | ~w(xs sm base lg | The size of the text. |
| `with_symbol` | `boolean` | Non | false | - | - |

**Exemple d'utilisation:**
```heex
<.waw_name value={%{name: "4212TBA", custom_name: "ix35", label: "TGP0012", tracker_label: "MD0014"}} />
    <.waw_name size="sm" value={%{label: "TGP0012", name: "4212TBA", custom_name: "ix35", tracker_label: "MD0014", trackable_symbol: "car"}} with_symbol/>
```

---

## Composants de structure

### waw_block_list_container

**Module:** `Waw.BlockListContainer`

**Description:** Afficher conteneur de liste de blocs.

**Import:**
```elixir
import Waw.Delegates  # ou use Waw
```

---

### waw_block_separator

**Module:** `Waw.BlockSeparator`

**Description:** Séparateur de blocs.

**Import:**
```elixir
import Waw.Delegates  # ou use Waw
```

---

### waw_block_title

**Module:** `Waw.BlockTitle`

**Description:** Titre de bloc.

**Import:**
```elixir
import Waw.Delegates  # ou use Waw
```

---

## Composants de formulaire

### waw_checkbox_list

**Module:** `Waw.CheckboxList`

**Description:** Afficher une liste de checkbox.

**Import:**
```elixir
import Waw.Delegates  # ou use Waw
```

---

### waw_input

**Module:** `Waw.Input`

**Description:** Afficher les champs de saisie.

**Description détaillée:** Afficher differents types de champs de saisie.

**Import:**
```elixir
import Waw.Delegates  # ou use Waw
```

**Attributs:**

| Attribut | Type | Requis | Défaut | Valeurs | Description |
|----------|------|--------|--------|---------|-------------|
| `id` | `any` | Non | nil | - | - |
| `name` | `any` | Non | - | - | - |
| `label` | `any` | Non | nil | - | - |
| `value` | `any` | Non | - | - | - |
| `step` | `any` | Non | - | - | - |
| `list` | `any` | Non | - | - | - |
| `max` | `string` | Non | - | - | - |
| `min` | `string` | Non | - | - | - |
| `type` | `string` | Non | text | ~w(checkbox color date datetime-local email fil... | - |
| `errors` | `list` | Non | [] | - | - |
| `checked` | `boolean` | Non | - | - | the checked flag for checkbox inputs |
| `invert_choice` | `boolean` | Non | false | - | Pour le checkbox-choices permet d'inverser le choix |
| `prompt` | `string` | Non | nil | - | the prompt for select inputs |
| `options` | `list` | Non | - | - | the options to pass to Phoenix.HTML.Form.options_for_select/2 |
| `multiple` | `boolean` | Non | false | - | the multiple flag for select inputs |
| `password_is_visible` | `boolean` | Non | false | - | check if passwordis visible |
| `tooltip_is_visible` | `boolean` | Non | false | - | - |
| `add_on` | `boolean` | Non | false | - | - |
| `visible` | `boolean` | Non | true | - | - |
| `add_on_text` | `string` | Non | - | - | - |
| `textarea_value` | `string` | Non | - | - | - |
| `placeholder` | `string` | Non | - | - | - |
| `size` | `string` | Non | lg | ["xs" | - |
| `popup_is_visible` | `boolean` | Non | false | - | - |
| `text_type` | `string` | Non | text | ["text" | - |
| `icon` | `string` | Non | - | Waw.Icons.icon_list( | Icon name |
| `error` | `string` | Non | - | - | - |

**Slots:**

- `:inner_block`
- `:tooltip_block`

---

## Composants de données

### waw_dashboard

**Module:** `Waw.Dashboard`

**Description:** Dashboard de tag-ip

**Import:**
```elixir
import Waw.Delegates  # ou use Waw
```

**Attributs:**

| Attribut | Type | Requis | Défaut | Valeurs | Description |
|----------|------|--------|--------|---------|-------------|
| `with_padding` | `boolean` | Non | false | - | - |
| `title` | `string` | Non | - | - | Titre de la section |

---

### waw_dashboard_card

**Module:** `Waw.DashboardCard`

**Description:** Afficher une carte avec camembert ou graphe comme contenu.

**Description détaillée:** Afficher une carte avec camembert ou graphe comme contenu.

**Import:**
```elixir
import Waw.Delegates  # ou use Waw
```

**Attributs:**

| Attribut | Type | Requis | Défaut | Valeurs | Description |
|----------|------|--------|--------|---------|-------------|
| `title` | `string` | Non | - | - | - |
| `description` | `string` | Non | Aucune description disponible | - | - |
| `icon` | `string` | Non | - | - | - |

**Slots:**

- `:inner_block`

**Exemple d'utilisation:**
```heex
<.waw_dashboard_card
      title="statistique par type"
      description="Information concernant le départ des véhicules"
      icon="clock"
    >
      <div class="grid place-content-center p-4 h-full">
        Pie content
      </div>
    </.waw_dashboard_card>
```

---

### waw_dl

**Module:** `Waw.DefinitionList`

**Description:** Afficher une liste de définitions.

**Description détaillée:** Afficher la liste de definitions.

**Import:**
```elixir
import Waw.Delegates  # ou use Waw
```

**Slots:**

- `:inner_block`

**Exemple d'utilisation:**
```heex
<.waw_dl>
      <.waw_definition term="term" description="description" text_align="left">
        <:actions>
          <.waw_link_icon size="sm" state="checked" icon="square-and-pencil"/>
        </:actions>
      </.waw_definition>

      <.waw_definition term="term" description="description" text_align="left">
        <:actions>
          <.waw_link_icon size="sm" state="checked" icon="square-and-pencil" disabled/>
        </:actions>
      </.waw_definition>

      <.waw_definition term="term" description="description" text_align="left" />
    </.waw_dl>
```

---

### waw_definition

**Module:** `Waw.DefinitionList`

**Description:** Afficher une liste de définitions.

**Description détaillée:** Afficher l'élément de la definition.

**Import:**
```elixir
import Waw.Delegates  # ou use Waw
```

**Slots:**

- `:inner_block`
- `:actions` - Action button for edition.
- `:inner_block` - Description block.

**Exemple d'utilisation:**
```heex
<.waw_definition term="term" description="description" text_align="left">
      <:actions>
        <.waw_link_icon size="sm" state="checked" icon="square-and-pencil"/>
      </:actions>
    </.waw_definition>
```

---

### waw_list_header

**Module:** `Waw.ListHeader`

**Description:** Afficher un header de liste pour le tri.

**Import:**
```elixir
import Waw.Delegates  # ou use Waw
```

---

### waw_pagination

**Module:** `Waw.Pagination`

**Description:** Afficher une pagination.

**Import:**
```elixir
import Waw.Delegates  # ou use Waw
```

---

### waw_stat

**Module:** `Waw.Stat`

**Description:** Une carte statistique affichant une valeur

**Description détaillée:** Afficher une carte statistique.

**Import:**
```elixir
import Waw.Delegates  # ou use Waw
```

**Attributs:**

| Attribut | Type | Requis | Défaut | Valeurs | Description |
|----------|------|--------|--------|---------|-------------|
| `title` | `string` | Oui | - | - | - |
| `icon` | `string` | Non | info-circle-fill | icon_list( | - |
| `value` | `string` | Non | - | - | Valeur à afficher |
| `start_value` | `string` | Non | - | - | Valeur à afficher |
| `end_value` | `string` | Non | nil | - | Valeur à afficher |
| `col` | `integer` | Non | 1 | - | Nombre de colonne |
| `is_clickable` | `boolean` | Non | false | - | - |
| `loading` | `boolean` | Non | false | - | - |
| `unit` | `atom` | Non | nil | [nil | Cldr.Unit.known_units( | - |
| `previous_value` | `integer` | Non | - | - | Ancienne valeur |
| `variation_unit` | `atom` | Non | nil | [nil | - |
| `variation_symbol` | `atom` | Non | :arrow | [
      :math | - |
| `status` | `atom` | Non | :info | [:info | - |
| `description` | `string` | Non | Aucune description disponible | - | - |
| `total` | `integer` | Non | - | - | Total à comparer avec la valeur |
| `ratio` | `atom` | Non | nil | [nil | - |
| `at` | `any` | Non | - | - | Date et heure de la valeur |

**Exemple d'utilisation:**
```heex
<.waw_stat
      total={251}
      unit={:kilometer}
      value={100}
      title="véhicules géolocalisés"
      icon="nom-inconnu" # utilisera "info-circle-fill" par défaut
    />
```

---

### waw_status_block

**Module:** `Waw.StatusBlock`

**Description:** Afficher une bloc de status.

**Description détaillée:** Afficher une bloc de status.

**Import:**
```elixir
import Waw.Delegates  # ou use Waw
```

**Attributs:**

| Attribut | Type | Requis | Défaut | Valeurs | Description |
|----------|------|--------|--------|---------|-------------|
| `icon` | `string` | Non | info-circle-fill | - | icon name of the card status. |
| `title` | `string` | Non | - | - | name of the card status. |
| `status` | `atom` | Non | :info | [:info | - |

**Slots:**

- `:right` - Action or status on the right of the header
- `:content`
- `:table`
- `:pagination`

**Exemple d'utilisation:**
```heex
<.waw_status_block status={:success} title="Informations balise GPS" icon="tracker">
      <:right>
        <span>Connectée</span>
      </:right>
      <:content>
        <.waw_status_block_content col={2} label="Dernière position" value="10:53:10  31 oct. 2023, -12.31027, 49.30167" />
      </:content>
    </.waw_status_block>
```

---

### waw_status_card

**Module:** `Waw.StatusCard`

**Description:** Afficher la carte de status.

**Description détaillée:** Afficher la carte de status.

**Import:**
```elixir
import Waw.Delegates  # ou use Waw
```

**Attributs:**

| Attribut | Type | Requis | Défaut | Valeurs | Description |
|----------|------|--------|--------|---------|-------------|
| `label` | `string` | Non | Toutes les informations | - | name of the card status. |
| `icon` | `string` | Non | square-stack-3d-up-fill | - | icon name of the card status. |
| `state` | `string` | Non | normal | ["normal" | - |
| `text_size` | `string` | Non | sm | ["xs" | - |

**Exemple d'utilisation:**
```heex
<.waw_status_card label="Localisation" icon="world" />
```

---

### waw_table

**Module:** `Waw.Table`

**Description:** Afficher le tableau Tag-IP.

**Description détaillée:** Afficher le tableau Tag-IP.

**Import:**
```elixir
import Waw.Delegates  # ou use Waw
```

**Attributs:**

| Attribut | Type | Requis | Défaut | Valeurs | Description |
|----------|------|--------|--------|---------|-------------|
| `without_border` | `boolean` | Non | false | - | - |
| `state` | `string` | Non | - | ["normal" | - |

**Slots:**

- `:inner_block`
- `:thead` - The head on the table

**Exemple d'utilisation:**
```heex
<.waw_table>
      <:thead>
        <.waw_th sort_key="desc">Name</.waw_th>
        <.waw_th sort_key="asc">First Name</.waw_th>
      </:thead>
      <:tr state="selected">
        <.waw_td title="Jean">Jean</.waw_td>
        <.waw_td title="Dupont">Dupoint</.waw_td>
      </:tr>
      <:tr state="normal">
        <.waw_td title="Kim">Kim</.waw_td>
        <.waw_td title="Léna" is_link={true} href="https://www.tag-ip.com/">Léna</.waw_td>
      </:tr>
      <:tr state="disabled">
        <.waw_td title="Sam">Sam</.waw_td>
        <.waw_td title="Smith">Smith</.waw_td>
      </:tr>
    </.waw_table>
```

---

### waw_tag_list

**Module:** `Waw.TagList`

**Description:** Afficher une liste de tags.

**Import:**
```elixir
import Waw.Delegates  # ou use Waw
```

---

## Composants de navigation

### waw_filter_header

**Module:** `Waw.FilterHeader`

**Description:** Afficher le header des filtres.

**Description détaillée:** Afficher le header des filtres.

**Import:**
```elixir
import Waw.Delegates  # ou use Waw
```

**Attributs:**

| Attribut | Type | Requis | Défaut | Valeurs | Description |
|----------|------|--------|--------|---------|-------------|
| `id` | `string` | Oui | - | - | - |
| `bordered` | `boolean` | Non | true | - | - |

**Slots:**

- `:left`
- `:center`
- `:right`
- `:filter`

**Exemple d'utilisation:**
```heex
<.waw_filter_header>
    <:left>
      <div>03/09/23 00:00:00</div>
    </:left>
    <:filter>
      <.waw_nav_filter value={120} icon="car" description="car" />
    </:filter>
    <:filter>
      <.waw_nav_filter value={25} icon="moto">
    </:filter>
    <:filter>
      <.waw_nav_filter value={145} title="Total:" active description="Nombre total">
    </:filter>
  </.waw_filter_header>
```

---

### waw_nav_filter

**Module:** `Waw.FilterHeader`

**Description:** Afficher le header des filtres.

**Description détaillée:** Afficher l' élément du filtre.

**Import:**
```elixir
import Waw.Delegates  # ou use Waw
```

**Attributs:**

| Attribut | Type | Requis | Défaut | Valeurs | Description |
|----------|------|--------|--------|---------|-------------|
| `id` | `string` | Oui | - | - | - |
| `bordered` | `boolean` | Non | true | - | - |

**Slots:**

- `:left`
- `:center`
- `:right`
- `:filter`
- `:icon`

**Exemple d'utilisation:**
```heex
<.waw_nav_filter />
```

---

### waw_footer

**Module:** `Waw.Footer`

**Description:** Afficher le footer de Tag-IP.

**Import:**
```elixir
import Waw.Delegates  # ou use Waw
```

---

### waw_header

**Module:** `Waw.Header`

**Description:** Ceci est l'en-tete classique de Tag-IP - à gauche nous avons le logo du produit - puis le titre de la page - à droite nous avons quelques entrees (liens) - puis nous avons la barre de recherche dans un slot - puis les boutons - puis en dernier l'icone de l'utilisateur qui ouvre un menu

**Description détaillée:** Afficher l'en-tête de Tag-IP.

**Import:**
```elixir
import Waw.Delegates  # ou use Waw
```

**Attributs:**

| Attribut | Type | Requis | Défaut | Valeurs | Description |
|----------|------|--------|--------|---------|-------------|
| `logo` | `string` | Non | tag-ip | Logo.list( | - |
| `logo_url` | `string` | Non | https://tag-ip.com | - | L'url
    de la page du logo |
| `title` | `string` | Non | - | - | Le titre de la page courante |
| `subtitle` | `string` | Non | - | - | Le sous-titre de la page courante |
| `is_dark` | `boolean` | Non | false | - | - |
| `connected_user` | `map` | Non | - | - | L'utilisateur `E.Gereg.User` connecté |
| `current_user` | `map` | Non | - | - | L'utilisateur `E.Gereg.User` courant |
| `user_home_url` | `string` | Non | - | - | L'URL de la page d'accueil de
    l'utilisateur courant |
| `connected_user_profile_url` | `string` | Non | - | - | L'URL de la page de profil de l'utilisateur
    connecté |
| `current_user_profile_url` | `string` | Non | - | - | L'URL de la page de profil de l'utilisateur
    courant |
| `logout_url` | `string` | Non | - | - | L'URL de la page de deconnexion de
    l'utilisateur courant |
| `notification_action` | `any` | Non | - | - | Action lors du click sur les
    notifications, afficher la cloche si cet att... |
| `has_notifications` | `boolean` | Non | false | - | Afficher un marqueur
    rouge si cet attribut est vrai |
| `header_id` | `string` | Non | header | - | L'id DOM de l'en-tête,
    optionnel, utilise surtout dans storybook |
| `active` | `boolean` | Non | - | - | Lien actif |
| `disabled` | `boolean` | Non | - | - | Lien désactivé |
| `action` | `any` | Non | - | - | Action lors du click sur le lien |
| `navigate` | `string` | Non | - | - | Lien de navigation |
| `tooltip` | `string` | Non | - | - | Tooltip sur le hover |
| `href` | `string` | Non | - | - | Lien de navigation |

**Slots:**

- `:menu_entry` - Une entrée du menu
- `:actions` - Une action dans le header

---

### waw_panel_header

**Module:** `Waw.PanelHeader`

**Description:** Afficher l'en-tête du panneau.

**Description détaillée:** Afficher l'en-tête du panneau.

**Import:**
```elixir
import Waw.Delegates  # ou use Waw
```

**Attributs:**

| Attribut | Type | Requis | Défaut | Valeurs | Description |
|----------|------|--------|--------|---------|-------------|
| `icon` | `string` | Non | menu-burger | [
      "truck" | - |
| `selected` | `boolean` | Non | false | - | - |
| `bordered` | `boolean` | Non | true | - | - |
| `title` | `string` | Oui | - | - | - |
| `subtitle` | `string` | Non | - | - | - |
| `description` | `string` | Non | nil | - | - |
| `subtitle_type` | `string` | Non | muted | ["success" | - |
| `title_type` | `string` | Non | selected | ["normal" | - |
| `acronym` | `string` | Non | - | - | - |
| `icon_color` | `string` | Non | default-primary | - | - |

**Slots:**

- `:actions`

**Exemple d'utilisation:**
```heex
<.waw_panel_header title="Title" />
```

---

### waw_step_list

**Module:** `Waw.StepList`

**Description:** Parcourir une liste.

**Import:**
```elixir
import Waw.Delegates  # ou use Waw
```

---

### waw_steps

**Module:** `Waw.Steps`

**Description:** Afficher le steps.

**Import:**
```elixir
import Waw.Delegates  # ou use Waw
```

---

### waw_subheader

**Module:** `Waw.Subheader`

**Description:** Afficher le sous header.

**Description détaillée:** Afficher le sous header.

**Import:**
```elixir
import Waw.Delegates  # ou use Waw
```

**Attributs:**

| Attribut | Type | Requis | Défaut | Valeurs | Description |
|----------|------|--------|--------|---------|-------------|

**Slots:**

- `:center`
- `:breadcrumb`
- `:right`

**Exemple d'utilisation:**
```heex
<.waw_subheader>
      <:breadcrumb>
        <.waw_nav_breadcrumb>
          <.waw_icons name="home" size="4" />
        </.waw_nav_breadcrumb>
      </:breadcrumb>
      <:breadcrumb>
        <.waw_nav_breadcrumb>2MI</.nav_breadcrumb>
      </:breadcrumb>
      <:breadcrumb>
          <.waw_nav_breadcrumb active>Vue globale</.waw_nav_breadcrumb>
      </:breadcrumb>
      <:right>
        <div>03/09/23 00:00:00</div>
      </:right>
    </.waw_subheader>
```

---

### waw_nav_breadcrumb

**Module:** `Waw.Subheader`

**Description:** Afficher le sous header.

**Description détaillée:** Afficher l' élément du breadcrumb.

**Import:**
```elixir
import Waw.Delegates  # ou use Waw
```

**Attributs:**

| Attribut | Type | Requis | Défaut | Valeurs | Description |
|----------|------|--------|--------|---------|-------------|

**Slots:**

- `:center`
- `:breadcrumb`
- `:right`
- `:inner_block`

**Exemple d'utilisation:**
```heex
<.nav_breadcrumb>
    ...
  </.nav_breadcrumb>
```

---

### waw_tabs

**Module:** `Waw.Tabs`

**Description:** Afficher les onglets.

**Description détaillée:** Afficher les onglets.

**Import:**
```elixir
import Waw.Delegates  # ou use Waw
```

**Attributs:**

| Attribut | Type | Requis | Défaut | Valeurs | Description |
|----------|------|--------|--------|---------|-------------|
| `align_tab` | `string` | Non | left | ~w(left center right | The tab alignment |
| `size` | `string` | Non | lg | ~w(sm lg | The size for the tab component only. |

**Slots:**

- `:actions` - Actions on the right
- `:inner_block`

**Exemple d'utilisation:**
```heex
<.waw_tabs size="sm" align_tab="left">
      <.waw_tab size="sm" active>
        Items
      </.waw_tab>
      <.waw_tab size="sm">
        Flottes
      </.waw_tab>
      <.waw_tab size="sm" disabled>
        Instances
      </.waw_tab>
      <:actions>
        <.waw_button label="Créer" size="sm" />
        <.waw_button label="Rafraîchir" size="sm" icon="home" />
        <.inputs id="inputs-single-search-litle" size="sm" type="search"/>
      </:actions>
    </.waw_tabs>
```

---

### waw_tab

**Module:** `Waw.Tabs`

**Description:** Afficher les onglets.

**Description détaillée:** Afficher le tab.

**Import:**
```elixir
import Waw.Delegates  # ou use Waw
```

**Attributs:**

| Attribut | Type | Requis | Défaut | Valeurs | Description |
|----------|------|--------|--------|---------|-------------|
| `align_tab` | `string` | Non | left | ~w(left center right | The tab alignment |
| `size` | `string` | Non | lg | ~w(sm lg | The size for the tab component only. |

**Slots:**

- `:actions` - Actions on the right
- `:inner_block`
- `:inner_block`

**Exemple d'utilisation:**
```heex
<.waw_tab size="sm" active>
      Items
    </.waw_tab>
    <.waw_tab size="sm">
      Flottes
    </.waw_tab>
    <.waw_tab size="sm" disabled>
      Instances
    </.waw_tab>
```

---

## Composants LiveView

### waw_live_button

**Module:** `Waw.LiveButton`

**Description:** Afficher le component button collapse

**Description détaillée:** Afficher un button collapse.

**Import:**
```elixir
import Waw.Delegates  # ou use Waw
```

**Attributs:**

| Attribut | Type | Requis | Défaut | Valeurs | Description |
|----------|------|--------|--------|---------|-------------|
| `search_name` | `string` | Non | input_name | - | - |
| `placeholder` | `string` | Non | Rechercher | - | - |
| `show_menu` | `boolean` | Non | false | - | - |
| `show_list` | `boolean` | Non | false | - | - |
| `full_width` | `boolean` | Non | false | - | - |
| `is_in_subheader` | `boolean` | Non | false | - | - |
| `with_search` | `boolean` | Non | false | - | - |
| `type` | `atom` | Non | :list | [:list | - |
| `selected_item` | `string` | Non | - | - | - |
| `size` | `string` | Non | md | ~w(xs sm md lg | The size of the component. |

**Slots:**

- `:results`
- `:left`
- `:right`
- `:actions`
- `:column`

---

### waw_live_filter

**Module:** `Waw.LiveFilter`

**Description:** Filtre d'une liste avec recherche.

**Description détaillée:** Filtre d'une liste avec recherche.

**Import:**
```elixir
import Waw.Delegates  # ou use Waw
```

**Attributs:**

| Attribut | Type | Requis | Défaut | Valeurs | Description |
|----------|------|--------|--------|---------|-------------|
| `list` | `list` | Oui | - | - | - |

**Slots:**

- `:left`
- `:right`

**Exemple d'utilisation:**
```heex
<.waw_live_filter>

    </.waw_live_filter>
```

---

### waw_live_search

**Module:** `Waw.LiveSearch`

**Description:** Afficher un champs de recherche avec un resultat dans un popup.

**Description détaillée:** Afficher un champs de recherche avec un resultat dans un popup.

**Import:**
```elixir
import Waw.Delegates  # ou use Waw
```

**Exemple d'utilisation:**
```heex
<.waw_live_search
      placeholder="Rechercher"
      name="nom_de_la_recherche"
      phx-change={}
      phx-target={}
      on_blur="blur"
    >
      <:results>
        <.waw_list_group title="Organisations">
          <.waw_li_button>org 1</.waw_li_button>
          <.waw_li_button>org 2</.waw_li_button>
        </.waw_list_group>
        <.waw_list_group title="Flottes">
          <.waw_li_button>flotte 1</.waw_li_button>
          <.waw_li_button>flotte 2</.waw_li_button>
        </.waw_list_group>
      </:results>
    </.waw_live_search>
```

---

## Pages

### waw_page_error

**Module:** `Waw.Pages.PageError`

**Description:** Afficher une page d'erreur

**Description détaillée:** Afficher une page d'erreur

**Import:**
```elixir
import Waw.Delegates  # ou use Waw
```

**Attributs:**

| Attribut | Type | Requis | Défaut | Valeurs | Description |
|----------|------|--------|--------|---------|-------------|
| `title` | `string` | Non | Page introuvable | - | The error title |
| `text` | `string` | Non | ...On a perdu votre page dans l'espace-temps | - | The error text |
| `url` | `string` | Non | - | - | Url of the page |

**Slots:**

- `:background_image` - Background-image
- `:actions` - link from button

**Exemple d'utilisation:**
```heex
<.waw_page_error url="https://tag-ip.com">
    <:background_image>
      <div class="background-image-astro">
      </div>
    </:background_image>
    <:actions>
      <.link>
        Revenez à la base
      </.link>
    </:actions>
  </.waw_page_error>
```

---

## Templates

### waw_fixed_header_footer

**Module:** `Waw.Templates.FixedHeaderFooter`

**Description:** Template fixer le header et footer

**Description détaillée:** Afficher le template qui fixe le header et footer.

**Import:**
```elixir
import Waw.Delegates  # ou use Waw
```

**Slots:**

- `:header`
- `:subheader`
- `:filter_header`
- `:main`
- `:footer`

**Exemple d'utilisation:**
```heex
<.waw_fixed_header_footer>
    <:header>
      <.waw_header title="Démo" log_out_url="" profile_url="">
        <:nav>
          ...
        </:nav>
        <:actions>
          ...
        </:actions>
      </.waw_header>
    </:header>
    <:subheader>
      ...
    </:subheader>
    <:main>
      ...
    </:main>
    <:footer>
      <.waw_footer local_time="00:00:00" copyright_year="2023" utc_time="00:00:00" />
    </:footer>
  </.waw_fixed_header_footer>
```

---

### waw_icon_title_action

**Module:** `Waw.Templates.IconTitleAction`

**Description:** Template icon-title-action.

**Description détaillée:** Afficher le template à 3 elements: icone-titre(label)-action(boutons).

**Import:**
```elixir
import Waw.Delegates  # ou use Waw
```

**Attributs:**

| Attribut | Type | Requis | Défaut | Valeurs | Description |
|----------|------|--------|--------|---------|-------------|
| `class` | `string` | Non | default | ["default" | - |

**Slots:**

- `:icon`
- `:label`
- `:action`

**Exemple d'utilisation:**
```heex
<.icon_title_action>
    <:icon>
      <.waw_icon name="truck"/>
    </:icon>
    <:label>
    label
    </:label>
    <:action>
      <div>
        <.waw_icon name="caret-down"/>
        <.waw_icon name="caret-down"/>
        <.waw_icon name="caret-down"/>
      </div>
    </:action>
  </.icon_title_action>
```

---

## Composants de formatage

### waw_interval

**Module:** `Waw.Text.Dates`

**Description:** Une composante qui affiche une date, ou une heure. ou une intervalle de temps.

**Import:**
```elixir
import Waw.Delegates  # ou use Waw
```

**Attributs:**

| Attribut | Type | Requis | Défaut | Valeurs | Description |
|----------|------|--------|--------|---------|-------------|
| `from` | `any` | Oui | - | - | Le début de l'intervalle |
| `to` | `any` | Oui | - | - | La fin de l'intervalle |
| `format` | `any` | Non | :medium | - | - |
| `style` | `any` | Non | - | - | - |

---


## Notes importantes

- Tous les composants sont disponibles via `import Waw.Delegates` ou `use Waw`
- Les attributs marqués comme `:global` (comme `rest`) acceptent tous les attributs HTML et Phoenix
- Les composants utilisent Tailwind CSS pour le styling
- Pour les formulaires, utilisez toujours `to_form/2` pour créer les formulaires
- Consultez `lib/waw/delegates.ex` pour la liste complète des fonctions déléguées