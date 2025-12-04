defmodule WawShowcase.UIConfig do
  @moduledoc """
  Configuration statique des composants UI organisés par catégorie et sous-catégorie.
  Chaque sous-catégorie a un composant principal (celui avec le code source le plus court)
  et des variantes.
  """

  @ui_components %{
    "Basiques" => [
      %{
  sous_categorie: "Accordion",
        module: "Waw.Accordion",
        principal: %{
          nom: "Accordion",
          code_source: """
<.waw_accordion count={12} id="accordion-single-normal" has_group>
<.waw_accordion id="accordion-2" head_icon="truck" title="Truck" count={8}>
<.waw_table without_border>
<:thead>
<.waw_th></.waw_th>
<.waw_th>Véhicules</.waw_th>
<.waw_th sort_key="asc">Heure</.waw_th>
</:thead>
<:tr state="selected">
<.waw_td_icon><.waw_icon name="car" stroke="none" size="4" /></.waw_td_icon>
<.waw_td title="6541 TBA" is_link={true} href="https://www.tag-ip.com/">
6541 TBA
<:description>Vitesse > 60km/h</:description>
</.waw_td>
<.waw_td title="14:42:37">14:42:37</.waw_td>
</:tr>
<:tr state="normal">
<.waw_td_icon><.waw_icon name="car" stroke="none" size="4" /></.waw_td_icon>
<.waw_td title="3354 TBS">
3354 TBS
<:description>Vitesse > 70km/h</:description>
</.waw_td>
<.waw_td title="14:42:37">14:42:37</.waw_td>
</:tr>
<:tr state="disabled">
<.waw_td_icon><.waw_icon name="car" stroke="none" size="4" /></.waw_td_icon>
<.waw_td title="3354 TBA">
3354 TBA
<:description>Vitesse > 50km/h</:description>
</.waw_td>
<.waw_td title="14:42:37">14:42:37</.waw_td>
</:tr>
</.waw_table>
</.waw_accordion>
<.waw_accordion id="accordion-3" head_icon="moto" title="moto" />
</.waw_accordion>
"""
        },
        variantes: [
          %{
            nom: "Avec status sélectionné",
            code_source: """
<.waw_accordion count={12} id="accordion-single-table" selected head_icon="car">
<.waw_table without_border>
<:thead>
<.waw_th sort_key="desc"></.waw_th>
<.waw_th sort_key="desc">Véhicules</.waw_th>
<.waw_th sort_key="asc">Evenement</.waw_th>
</:thead>
<:tr state="selected">
<.waw_td_icon><.waw_icon name="car" stroke="none" size="4" /></.waw_td_icon>
<.waw_td title="6541 TBA">6541 TBA</.waw_td>
<.waw_td title="Vitesse > 60km/h" is_link={true} href="https://www.tag-ip.com/">Vitesse > 60</.waw_td>
</:tr>
<:tr state="disabled">
<.waw_td_icon><.waw_icon name="car" stroke="none" size="4" /></.waw_td_icon>
<.waw_td title="3354 TBA">3354 TBA</.waw_td>
<.waw_td title="Vitesse > 50km/h">Vitesse > 50</.waw_td>
</:tr>
</.waw_table>
</.waw_accordion>
"""
},
        ]
      },
      %{
  sous_categorie: "Badge",
        module: "Waw.Badge",
        principal: %{
          nom: "Badge",
          code_source: """
<.waw_badge id="badge-single-default" label="value" color="#12dba2"/>
"""
        },
        variantes: [
          %{
            nom: "Avec bouton fermer",
            code_source: """
<.waw_badge id="badge-single-standard" label="value" description="title" color="info">
  <:action>
  <.waw_button_icon icon="cancel" />
  </:action>
</.waw_badge>
"""
          },
          %{
            nom: "Avec étiquette",
            code_source: """
<.waw_badge id="badge-single-scope" label="value" scope="scope" description="Avec étiquette" color="danger"/>
"""
          },
          %{
            nom: "Avec étiquette et bouton fermer",
            code_source: """
<.waw_badge id="badge-single-scope-complete" label="value" scope="scope" description="Avec étiquette" color="#B1159C">
  <:action>
  <.waw_button_icon icon="cancel" bg_color="bg-light" />
  </:action>
</.waw_badge>
"""
},
        ]
      },
      %{
        sous_categorie: "Séparateur de blocs",
        module: "Waw.BlockSeparator",
        principal: %{
          nom: "Séparateur de blocs",
          code_source: """
<.waw_block_separator/>
"""
        },
        variantes: [
          %{
            nom: "Avec label",
            code_source: """
<.waw_block_separator label="4512 WWT"/>
"""
},
        ]
      },
      %{
        sous_categorie: "Titre de block",
        module: "Waw.BlockTitle",
        principal: %{
          nom: "Titre de bloc",
          code_source: """
<.waw_block_title label="Trackable sélectionné"/>
"""
        },
        variantes: [
          %{
            nom: "Avec icône",
            code_source: """
<.waw_block_title label="Trackable sélectionné" icon="car"/>
"""
},
        ]
      },
      %{
  sous_categorie: "Boutons",
        module: "Waw.Button",
        principal: %{
          nom: "Bouton",
          code_source: """
<.waw_button label="OK" size="md" type="submit"/>
"""
        },
        variantes: [
          %{
            nom: "Activé",
            code_source: """
<.waw_button label="Synthèse" size="md" state="checked" icon="circle-grid-3x3-fill" icon_position="left"/>
"""
          },
          %{
            nom: "Activé toggleable",
            code_source: """
<.waw_button label="Synthèse" size="md" state="checked" icon="circle-grid-3x3-fill" toggleable icon_position="left"/>
"""
          },
          %{
            nom: "Non-sélectionné",
            code_source: """
<.waw_button label="Evenements" size="md" state="unchecked" icon="square-stack-3d-up-fill"/>
"""
          },
          %{
            nom: "Plein désactivé",
            code_source: """
<.waw_button disabled label="home" size="md" state="checked" icon="home" icon_position="right"/>
"""
          },
          %{
            nom: "Désactivé",
            code_source: """
<.waw_button disabled label="label" size="md" state="unchecked" icon="home" icon_position="right"/>
"""
          },
          %{
            nom: "Annulation",
            code_source: """
<.waw_button label="Annuler" size="md" type="cancel"/>
"""
          },
          %{
            nom: "Groupe",
            code_source: """
<.waw_button_group position="left">
<.waw_button label="Organisation" size="md" icon="angle-small-down" icon_position="right" />
<.waw_button label="Flotte" size="md" icon="angle-small-down" icon_position="right" />
</.waw_button_group>
"""
},
        ]
      },
      %{
        sous_categorie: "Texte éditable",
        module: "Waw.ContentEditable",
        principal: %{
          nom: "Texte éditable",
          code_source: """
<.waw_contenteditable id="contenteditable-single-text" label="Name" value="Edit this name">
  <:status>
    <.waw_icon name="checkmark-icloud"/>
  </:status>
</.waw_contenteditable>
"""
        },
        variantes: [
        ]
      },
      %{
        sous_categorie: "Liste des champs avec description",
        module: "Waw.DefinitionList",
        principal: %{
          nom: "Liste de champs",
          code_source: """
<.waw_dl>
<.waw_definition text_align="left" term="term" has_actions={false}>
<p>description en block</p>
</.waw_definition>
<.waw_definition text_align="left" term="term" has_actions={false}>
<p>description en block</p>
</.waw_definition>
</.waw_dl>
"""
        },
        variantes: [
          %{
            nom: "Avec actions",
            code_source: """
<.waw_dl>
<.waw_definition text_align="left" term="term" description="description">
<:actions>
<.waw_link_icon size="sm" state="checked" icon="square-and-pencil"/>
</:actions>
</.waw_definition>
<.waw_definition text_align="left" term="term" description="description">
<:actions>
<.waw_link_icon size="sm" state="checked" icon="square-and-pencil" disabled/>
</:actions>
</.waw_definition>
<.waw_definition text_align="left" term="term" description="description" />
</.waw_dl>
"""
          },
          %{
            nom: "Avec description en bloc",
            code_source: """
<.waw_dl>
<.waw_definition text_align="left" term="term">
<:actions>
<.waw_link_icon size="sm" state="checked" icon="square-and-pencil"/>
</:actions>
<p>description en block</p>
</.waw_definition>
<.waw_definition text_align="left" term="term">
<:actions>
<.waw_link_icon size="sm" state="checked" icon="square-and-pencil" disabled/>
</:actions>
<p>description en block</p>
</.waw_definition>
</.waw_dl>
"""
          },
          %{
            nom: "Sans actions",
            code_source: """
<.waw_dl>
<.waw_definition text_align="left" term="term" description="description" has_actions={false} />
<.waw_definition text_align="left" term="term" description="description" has_actions={false} />
<.waw_definition text_align="left" term="term" description="description" has_actions={false} />
<.waw_definition text_align="left" term="term" description="description" has_actions={false} />
</.waw_dl>
"""
          },
        ]
      },
      %{
        sous_categorie: "Header des filtres",
        module: "Waw.FilterHeader",
        principal: %{
          nom: "Header des filtres",
          code_source: """
<.waw_filter_header id="filter-header-single-full">
<:left>
<.waw_button label="Organisation" size="md" icon="angle-small-down" icon_position="right" />
<.waw_button label="Flotte" size="md" icon="angle-small-down" icon_position="right" />
</:left>
<:filter>
<.waw_nav_filter value={120} icon="car" description="car" />
</:filter>
<:filter>
<.waw_nav_filter value={25} icon="moto" />
</:filter>
<:filter>
<.waw_nav_filter value={145} title="Total:" active description="Nombre total" />
</:filter>
</.waw_filter_header>
"""
        },
        variantes: [
          %{
            nom: "Avec sections gauche et droite",
            code_source: """
<.waw_filter_header id="filter-header-single--with-right">
<:left>
<.waw_button label="Organisation" size="md" icon="angle-small-down" icon_position="right" />
<.waw_button label="Flotte" size="md" icon="angle-small-down" icon_position="right" />
</:left>
<:right>
<.waw_button label="Actions" size="md" icon="ellipsis-circle" icon_position="right" />
<.live_search name="test" margin_size="lg">
<:results>
<.list_group title="Organisations">
<.li_button>org 1</.li_button>
<.li_button>org 2</.li_button>
</.list_group>
<.list_group title="Flottes">
<.li_button>flotte 1</.li_button>
<.li_button>flotte 2</.li_button>
</.list_group>
</:results>
</.live_search>
</:right>
</.waw_filter_header>
"""
},
        ]
      },
      %{
        sous_categorie: "Flash",
        module: "Waw.Flash",
        principal: %{
          nom: "Flash",
          code_source: """
<.waw_button type="button" phx-click={show("#:variation_id")} label="Ouvrir Flash" />
"""
        },
        variantes: [
          %{
            nom: "Message",
            code_source: """
<.waw_button type="button" phx-click={show("#:variation_id")} label="Ouvrir Flash" />
"""
},
        ]
      },
      %{
        sous_categorie: "Groupe de flash",
        module: "Waw.Flash",
        principal: %{
          nom: "Groupe de flashes",
          code_source: """
<.flash_group title="Notification" flash={%{"error" => "Serveur erreur."}}/>
"""
        },
        variantes: [
        ]
      },
      %{
  sous_categorie: "Footer",
        module: "Waw.Footer",
        principal: %{
          nom: "Footer",
          code_source: """
<.footer copyright_year={2025}/>
"""
        },
        variantes: [
        ]
      },
      %{
        sous_categorie: "Header",
        module: "Waw.Header",
        principal: %{
          nom: "Header",
          code_source: """
<.waw_header title="Titre de la page" current_user={%{id: 1, name: "Alice", email: "alice@example.com"}} header_id="notification" connected_user={%{id: 1, name: "Alice", email: "alice@example.com"}} notification_action={JS.toggle(to: "#notification_user_menu")} user_home_url="https://auth.tag-ip.com" has_i18n>
  <:menu_language navigate="en" href="/"> English </:menu_language>
  <:menu_language navigate="mg" href="/"> Malagasy </:menu_language>
</.waw_header>
"""
        },
        variantes: [
        ]
      },
      %{
        sous_categorie: "Champs",
        module: "WawShowcaseWeb.CoreComponents",
        principal: %{
          nom: "Champ",
          code_source: """
<.input type="search"/>
"""
        },
        variantes: [
          %{
            nom: "Texte",
            code_source: """
<.input label="label" size="sm" type="text" placeholder="Placeholder">
<:tooltip_block>
<.tooltip position="top" color="white" content="Information du tooltip" variant="arrow" margin="top">
(**)
</.tooltip>
</:tooltip_block>
</.input>
"""
          },
          %{
            nom: "Création flotte",
            code_source: """
<.input label="label" size="sm" type="text" placeholder="Placeholder">
<:tooltip_block>
<.tooltip position="top" color="white" content="Information du tooltip" variant="arrow" margin="top">
(**)
</.tooltip>
</:tooltip_block>
</.input>
"""
          },
          %{
            nom: "Description ou note",
            code_source: """
<.input label="label" size="sm" type="text" placeholder="Placeholder" text_type="textarea"/>
"""
          },
          %{
            nom: "E-mail",
            code_source: """
<.input label="label" size="sm" type="text" placeholder="name@tag_ip.com" text_type="email"/>
"""
          },
          %{
            nom: "Téléphone",
            code_source: """
<.input label="label" size="sm" type="number" icon="iphone" placeholder="Number" text_type="number"/>
"""
          },
          %{
            nom: "Checkbox",
            code_source: """
<.input label="label" type="checkbox"/>
"""
          },
          %{
            nom: "Heure",
            code_source: """
<.input label="label" size="sm" type="time"/>
"""
          },
          %{
            nom: "Date et heure",
            code_source: """
<.input label="label" size="sm" type="datetime-local"/>
"""
          },
          %{
            nom: "Recherche petite taille",
            code_source: """
<.input size="sm" type="search"/>
"""
          },
          %{
            nom: "Recherche avec popup",
            code_source: """
<.input type="search_without_border" popup_is_visible={true}>
<.li>item 1</.li>
<.li>item 2</.li>
</.input>
"""
          },
          %{
            nom: "Sélection",
            code_source: """
<.input label="Label" size="sm" type="select">
<option>option 1</option>
<option>option 2</option>
</.input>
"""
          },
          %{
            nom: "Sélection multiple",
            code_source: """
<.input label="Label" size="sm" type="select">
<option>option 1</option>
<option>option 2</option>
</.input>
"""
          },
        ]
      },
      %{
        sous_categorie: "Lien icône",
        module: "Waw.LinkIcon",
        principal: %{
          nom: "Lien icône",
          code_source: """
<.waw_link_icon size="sm" state="checked" icon="home"/>
"""
        },
        variantes: [
          %{
            nom: "Par défaut",
            code_source: """
<.waw_link_icon size="sm" state="unchecked" icon="home"/>
"""
},
        ]
      },
      %{
        sous_categorie: "Lien texte",
        module: "Waw.LinkText",
        principal: %{
          nom: "Lien texte",
          code_source: """
<.waw_link_text label="3 derniers jours" size="sm" state="unchecked"/>
"""
        },
        variantes: [
        ]
      },
      %{
        sous_categorie: "Element d'une liste",
        module: "Waw.List",
        principal: %{
          nom: "Liste",
          code_source: """
<.ul>
<.li acronym="T" state="selected" title="Tag-ip">Tag-ip</.li>
<.li acronym="2" title="2mi">2mi</.li>
<.li acronym="H" title="Holcim">Holcim</.li>
</.ul>
"""
        },
        variantes: [
          %{
            nom: "Complète avec statuts",
            code_source: """
<.ul>
<.li icon="person-fill" battery_number="30" connexion_status="normal">item 1</.li>
<.li icon="person-fill" state="selected"  battery_number="100" connexion_status="low">item 2</.li>
<.li icon="boat" connexion_status="moving">item 3</.li>
<.li icon="moto" connexion_status="offline">item 4</.li>
<.li icon="truck" state="selected" connexion_status="parked">item 5</.li>
<.li icon="car" connexion_status="defective">item 6</.li>
<.li icon="car" connexion_status="moving">item 7</.li>
<.li icon="person-fill" state="alert" battery_number="30" connexion_status="offline">item 8</.li>
<.li icon="person-fill" battery_number="75" connexion_status="low_activity">item 9</.li>
<.li icon="person-fill" battery_number="30" connexion_status="high_activity">item 10</.li>
<.li icon="person-fill" state="selected" battery_number="80" connexion_status="no_activity">item 11</.li>
<.li icon="person-fill" battery_number="80" connexion_status="power_off">item 12</.li>
<.li icon="lock-close-fill" lock_status="locked" battery_number="50" connexion_status="offline">item 13</.li>
<.li icon="lock-close-fill" state="selected" lock_status="unlocked" battery_number="30" connexion_status="high_activity">item 14</.li>
<.li icon="lock-close-fill" lock_status="locked" battery_number="50" connexion_status="low_activity">item 15</.li>
<.li icon="lock-close-fill" lock_status="unlocked" battery_number="30" connexion_status="no_activity">item 16</.li>
<.li icon="lock-close-fill" title="MD11802/DMY0029" lock_status="unlocked" battery_number="0" connexion_status="defective">item 17</.li>
</.ul>
"""
          },
          %{
            nom: "Classes d'événements",
            code_source: """
<.ul>
<.li icon="speedometer-1-right" total={5}>Cinématique</.li>
<.li icon="person" total={2} state="selected">Identification</.li>
<.li icon="world-fill" total={10}>Géographique</.li>
</.ul>
"""
},
        ]
      },
      %{
        sous_categorie: "Header de liste pour le tri",
        module: "Waw.ListHeader",
        principal: %{
          nom: "Header de liste",
          code_source: """
<.waw_list_header>
<:left>
<.waw_button_icon icon="caret-down" />
</:left>
<:center>
<.waw_button_icon icon="caret-down" />
</:center>
<:right>
<.waw_button_icon icon="caret-up" />
<.waw_button_icon icon="caret-down" />
<.waw_button_icon icon="caret-up" />
</:right>
</.waw_list_header>
"""
        },
        variantes: [
        ]
      },
      %{
        sous_categorie: "Bouton collapse",
        module: "Waw.LiveButton",
        principal: %{
          nom: "Bouton déroulant",
          code_source: """
<.live_button selected_item="Toutes les organisations" with_search={true} show_list={true} search_name="test">
<:results>
<.li_button active>Org 1</.li_button>
<.li_button>Org 2</.li_button>
</:results>
</.live_button>
"""
        },
        variantes: [
          %{
            nom: "Avec menus calendrier",
            code_source: """
<.live_button type={:menu} selected_item="Aujourd'hui" show_list={true}>
<:left>
<.waw_link_text label="3 derniers jours" size="xs" state="unchecked"/>
<.waw_link_text label="7 derniers jours" size="xs" state="checked" />
<.waw_link_text label="Cette semaine" size="xs" state="unchecked" />
</:left>
<:right>
<.waw_link_text label="Aujourd'hui" size="xs" state="unchecked" />
<.waw_link_text label="Hier" size="xs" state="unchecked" />
<.waw_link_text label="Avant hier" size="xs" state="unchecked" />
</:right>
<:actions>
<.input id="input-single-date" size="xs" type="date"/>
<.waw_icon name="arrow-small-right" size="4" />
<.input id="input-single-date2" size="xs" type="date"/>
<.waw_button label="Filtrer" size="xs" />
<.waw_button label="Annuler" size="xs" state="unchecked" />
</:actions>
</.live_button>
"""
          },
        ]
      },
      %{
        sous_categorie: "Filtre de gauche à droite avec recherche",
        module: "Waw.LiveFilter",
        principal: %{
          nom: "Filtre de liste",
          code_source: """
<.waw_live_filter list={[%{id: 1, value: "Item 1", selected: true}, %{id: 2, value: "Item 2"}, %{id: 3, value: "Item 3", selected: true}, %{id: 4, value: "Item 4"}, %{id: 5, value: "Item 5"}, %{id: 6, value: "Item 6", selected: true}, %{id: 7, value: "Item 7"}]}>
<:left>
<.waw_section_title>Elements disponibles</.waw_section_title>
<.input id="input-single-search-without-border" type="search_without_border" popup_is_visible>
<.li>item 1</.li>
<.li>item 2</.li>
</.input>
</:left>
<:right>
<.waw_section_title>Elements filtrés</.waw_section_title>
<.input id="input-single-search-without-border-2" type="search_without_border">
<.li>item 3</.li>
<.li>item 6</.li>
</.input>
</:right>
</.waw_live_filter>
"""
        },
        variantes: [
        ]
      },
      %{
        sous_categorie: "Recherche avec un resultat dans un popup",
        module: "Waw.LiveSearch",
        principal: %{
          nom: "Recherche avec popup",
          code_source: """
<.live_search name="test">
<:results>
<.list_group title="Organisations">
<.li_button>org 1</.li_button>
<.li_button>org 2</.li_button>
</.list_group>
<.list_group title="Flottes">
<.li_button>flotte 1</.li_button>
<.li_button>flotte 2</.li_button>
</.list_group>
</:results>
</.live_search>
"""
        },
        variantes: [
          %{
            nom: "Avec filtre",
            code_source: """
<.live_search name="test2" has_filter={true}>
<:results>
<.list_group title="Organisations">
<.li_button>org 1</.li_button>
<.li_button>org 2</.li_button>
</.list_group>
<.list_group title="Flottes">
<.li_button>flotte 1</.li_button>
<.li_button>flotte 2</.li_button>
</.list_group>
</:results>
<:filters>
<ul>
<.li state="selected" total={6}>Lister tous les items</.li>
<.li connexion_status="moving">2 En mouvement</.li>
<.li connexion_status="offline">4 Déconnectées</.li>
</ul>
</:filters>
</.live_search>
"""
},
        ]
      },
      %{
        sous_categorie: "Loading",
        module: "Waw.Loading",
        principal: %{
  nom: "Loading",
          code_source: """
<.loading/>
"""
        },
        variantes: [
        ]
      },
      %{
        sous_categorie: "Logos",
        module: "Waw.Logo",
        principal: %{
  nom: "Logo Tag-IP",
          code_source: """
<.logo name="tag-ip"/>
"""
        },
        variantes: [
        ]
      },
      %{
        sous_categorie: "Footer de carte",
        module: "Waw.MapFooter",
        principal: %{
          nom: "Footer de la carte",
          code_source: """
<.map_footer>
  <:left>
    <.head_section icon="flag-circle-fill" title="Localisation" />
    <.content id="left">
      <.section label="Date/heure" value="03/11/2023 à 10:53:01" description="03/11/2023 à 10:53:01" />
      <.section label="Position" value="-19,39916 ,47,4406" description="-19,39916 ,47,4406" />
      <.section label="Vitesse/Cap" value="33 km/h 198°" description="33 km/h 198°" />
      <.section label="Altitude" value="68 m" description="68 m" />
    </.content>
  </:left>
  <:right>
    <.head_section icon="car" title="Véhicule" />
    <.content id="right" col={2}>
      <.section label="Contact" value="OFF" description="OFF" />
      <.section label="Moteur" value="OFF" description="OFF" />
      <.section label="Odomètre" value="342 699,20 km" description="342 699,20 km" />
      <.section label="Carburant" value="171,7 l" description="171,7 l" />
      <.section label="RPM" value="0" description="0" />
    </.content>
  </:right>
</.map_footer>
"""
        },
        variantes: [
        ]
      },
      %{
        sous_categorie: "Header de carte",
        module: "Waw.MapHeader",
        principal: %{
          nom: "Header de la carte",
          code_source: """
<.map_header max={100} min={0} value={45} time="10:19:45" input_name="input-range" time_title="10:19:45">
<.waw_button_icon icon="playpause-left-fill" icon_size={5} title="Départ précédent" />
<.waw_button_icon icon="backward-end-alt-fill" icon_size={5} title="Evénement précédent" />
<.waw_button_icon icon="backward-end-fill" title="Point précédent"/>
<.waw_button_icon icon="play-fill" />
<.waw_button_icon icon="forward-end-fill" title="Point suivant" disabled />
<.waw_button_icon icon="forward-end-alt-fill" icon_size={5} title="Evénement suivant" disabled />
<.waw_button_icon icon="playpause-right-fill" icon_size={5} title="arrêt suivant" disabled />
<.waw_button_text label="X" value="4" title="Changer la vitesse de lecture" />
<.waw_button_icon icon="arrow-triangle-2-circlepath-refresh" />
</.map_header>
"""
        },
        variantes: [
        ]
      },
      %{
        sous_categorie: "Modal",
        module: "Waw.Modal",
        principal: %{
          nom: "Modal",
          code_source: """
<div>
<.waw_button type="button" phx-click={show_modal("modal-single-default-modal")} label="Ouvrir Modal" />
</div>
"""
        },
        variantes: [
        ]
      },
      %{
        sous_categorie: "Popup de notification",
        module: "Waw.NotificationPopup",
        principal: %{
          nom: "Popup de notification",
          code_source: """
<.notification_popup time="09:03:45" description="RENAULT MIDLUM 210 - 4785 TAG (Poids-lourds secondaires)" title="Survitesse en ville" icon="speedometer-1-right">
<:show>
<.waw_button_text label="Afficher" />
</:show>
<:closed>
<.waw_button_text label="Fermer" />
</:closed>
</.notification_popup>
"""
        },
        variantes: [
        ]
      },
      %{
  sous_categorie: "Pagination",
        module: "Waw.Pagination",
        principal: %{
          nom: "Pagination",
          code_source: """
<.waw_pagination label="Page" meta={%{current_page: 1, total_pages: 2, previous_page: nil, next_page: 2}} previous_page_action={nil} next_page_action={nil}/>
"""
        },
        variantes: [
          %{
            nom: "Simple",
            code_source: """
<.waw_pagination label="Page" total={9} current_page={1}>
<:left>
<.waw_button_icon icon="caret-left" icon_size={5} disabled />
</:left>
<:right>
<.waw_button_icon icon="caret-right" icon_size={5} />
</:right>
</.waw_pagination>
"""
},
        ]
      },
      %{
        sous_categorie: "Header d'un contenu",
        module: "Waw.PanelHeader",
        principal: %{
          nom: "Header de contenu",
          code_source: """
<.waw_panel_header title="Title"/>
"""
        },
        variantes: [
          %{
            nom: "Avec acronyme et sous-titre",
            code_source: """
<.waw_panel_header selected title="Acronyme" subtitle="55 En mouvement" acronym="A" subtitle_type="success"/>
"""
          },
          %{
            nom: "Avec bouton réduit",
            code_source: """
<.waw_panel_header title="Caret left" icon="truck">
<:actions>
<.waw_icon name="caret-left" size="6" />
</:actions>
</.waw_panel_header>
"""
          },
          %{
            nom: "Avec statut et bouton réduit",
            code_source: """
<.waw_panel_header title="Caret left" icon="truck" subtitle="À l'arrêt" subtitle_type="warning">
<:actions>
<.waw_icon name="caret-left" size="6" />
</:actions>
</.waw_panel_header>
"""
          },
          %{
            nom: "Avec statut et bouton déroulant",
            code_source: """
<.waw_panel_header title="Caret right" icon="car" subtitle="En mouvement" subtitle_type="success">
<:actions>
<.waw_icon name="caret-right" size="6" />
</:actions>
</.waw_panel_header>
"""
},
        ]
      },
      %{
        sous_categorie: "Bloc de status",
        module: "Waw.StatusBlock",
        principal: %{
          nom: "Bloc de status",
          code_source: """
<.waw_status_block title="Informations" icon="info-circle-fill">
<:content>
<.waw_status_block_content value="Le véhicule est au parking. La balise GPS est connectée." />
</:content>
</.waw_status_block>
"""
        },
        variantes: [
          %{
            nom: "Avec clé-valeur",
            code_source: """
<.waw_status_block title="Localisation" icon="world">
<:right>
<.waw_icon name="sign-out" size="4" stroke="none" />
</:right>
<:content>
<.waw_status_block_content col={2} label="Dernière position" value="-12.31027, 49.30167" />
<.waw_status_block_content col={2} label="Route et PK" value="-" />
</:content>
</.waw_status_block>
"""
          },
          %{
            nom: "Avec clé-valeur et status",
            code_source: """
<.waw_status_block status={:success} title="Informations balise GPS" icon="tracker">
<:right>
<span>Connectée</span>
</:right>
<:content>
<.waw_status_block_content col={2} label="Dernière position" value="10:53:10  31 oct. 2023, -12.31027, 49.30167" />
</:content>
</.waw_status_block>
"""
          },
          %{
            nom: "Avec liste de trajets",
            code_source: """
<.waw_status_block title="Compte-Rendu du trajet" icon="circuit">
<:table>
<.waw_table without_border>
<:thead>
<.waw_th>#</.waw_th>
<.waw_th>De</.waw_th>
<.waw_th>A</.waw_th>
<.waw_th>Durée</.waw_th>
<.waw_th>Distance</.waw_th>
</:thead>
<:tr state="selected">
<.waw_td>3</.waw_td>
<.waw_td title="08:05:52">08:05:52</.waw_td>
<.waw_td title="09:04:52">09:04:52</.waw_td>
<.waw_td title="1h14min34s">1h14min34s</.waw_td>
<.waw_td title="20km">20km</.waw_td>
</:tr>
<:tr state="normal">
<.waw_td>2</.waw_td>
<.waw_td title="07:05:52">07:05:52</.waw_td>
<.waw_td title="08:04:52">08:04:52</.waw_td>
<.waw_td title="14min34s">14min34s</.waw_td>
<.waw_td title="21km">21km</.waw_td>
</:tr>
<:tr state="normal">
<.waw_td>1</.waw_td>
<.waw_td title="06:05:52">06:05:52</.waw_td>
<.waw_td title="07:04:52">07:04:52</.waw_td>
<.waw_td title="14min34s">14min34s</.waw_td>
<.waw_td title="25km">25km</.waw_td>
</:tr>
</.waw_table>
</:table>
</.waw_status_block>
"""
},
        ]
      },
      %{
        sous_categorie: "Steps",
        module: "Waw.Steps",
        principal: %{
  nom: "Steps",
          code_source: """
<.waw_steps>
<:step status={:valid}>
Initialisation
</:step>
<:step status={:invalid} active>
Covoiturage
</:step>
<:step status={:disabled}>
Véhicule
</:step>
<:step status={:disabled}>
Chauffeur
</:step>
<:step status={:disabled} disabled>
Récapitulation
</:step>
</.waw_steps>
"""
        },
        variantes: [
        ]
      },
      %{
        sous_categorie: "Sous header",
        module: "WawShowcaseWeb.Components.Layout",
        principal: %{
          nom: "Sous header",
          code_source: """
<.subheader>
<:right>
<div>Texte à droite</div>
</:right>
</.subheader>
"""
        },
        variantes: [
          %{
            nom: "Fil d’Ariane",
            code_source: """
<.subheader>
<:breadcrumb>
<.nav_breadcrumb>
<.waw_icon name="home-fill" size="4" stroke="none" />
</.nav_breadcrumb>
</:breadcrumb>
<:breadcrumb>
<.nav_breadcrumb>2MI</.nav_breadcrumb>
</:breadcrumb>
<:breadcrumb>
<.nav_breadcrumb>Coursiers</.nav_breadcrumb>
</:breadcrumb>
<:breadcrumb>
<.nav_breadcrumb active>Vue globale</.nav_breadcrumb>
</:breadcrumb>
</.subheader>
"""
          },
          %{
            nom: "Complet",
            code_source: """
<.subheader>
<:breadcrumb>
<.nav_breadcrumb>
<.waw_icon name="home-fill" size="4" stroke="none" />
</.nav_breadcrumb>
</:breadcrumb>
<:breadcrumb>
<.nav_breadcrumb>2MI</.nav_breadcrumb>
</:breadcrumb>
<:breadcrumb>
<.nav_breadcrumb>Coursiers</.nav_breadcrumb>
</:breadcrumb>
<:breadcrumb>
<.nav_breadcrumb active>Vue globale</.nav_breadcrumb>
</:breadcrumb>
<:right>
<.interval
format={:short}
to={~U[2023-09-22 07:29:23.707953Z]}
from={~U[2023-09-22 06:13:14.707953Z]}
/>
<.live_search name="test">
<:results>
<.list_group title="Organisations">
<.li_button>org 1</.li_button>
<.li_button>org 2</.li_button>
</.list_group>
<.list_group title="Flottes">
<.li_button>flotte 1</.li_button>
<.li_button>flotte 2</.li_button>
</.list_group>
</:results>
</.live_search>
</:right>
</.subheader>
"""
},
        ]
      },
      %{
  sous_categorie: "Tableau",
        module: "Waw.Table",
        principal: %{
          nom: "Tableau",
          code_source: """
<.waw_table>
<:thead>
<.waw_th sort_key="desc">Name</.waw_th>
<.waw_th sort_key="asc">First Name</.waw_th>
</:thead>
<:tr state="selected">
<.waw_td title="Jean">Jean</.waw_td>
<.waw_td title="Dupont">Dupont</.waw_td>
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
"""
        },
        variantes: [
          %{
            nom: "Comptes-rendus flottes",
            code_source: """
<.waw_table>
<:thead>
<.waw_th_icon></.waw_th_icon>
<.waw_th_icon><.waw_icon name="circuit" stroke="none" size="4" /></.waw_th_icon>
<.waw_th sort_key="desc">Name</.waw_th>
<.waw_th sort_key="asc">First Name</.waw_th>
<.waw_th sort_key="desc">Details</.waw_th>
</:thead>
<:tr state="selected">
<.waw_td_icon><.waw_icon name="square-inset-filled" stroke="none" size="4" /></.waw_td_icon>
<.waw_td_icon><.waw_icon name="circuit" stroke="none" size="4" /></.waw_td_icon>
<.waw_td title="Jean">Jean</.waw_td>
<.waw_td title="Dupont">Dupoint</.waw_td>
<.waw_td_icon><.waw_icon name="square-stack-3d-up" stroke="none" size="4" /></.waw_td_icon>
</:tr>
<:tr state="normal">
<.waw_td_icon><.waw_icon name="square" stroke="none" size="4" /></.waw_td_icon>
<.waw_td_icon><.waw_icon name="circuit" stroke="none" size="4" /></.waw_td_icon>
<.waw_td title="Kim">Kim</.waw_td>
<.waw_td title="Léna">Léna</.waw_td>
<.waw_td_icon is_link={true} href="https://www.tag-ip.com/"><.waw_icon name="square-stack-3d-up" stroke="none" size="4" /></.waw_td_icon>
</:tr>
<:tr state="disabled">
<.waw_td_icon><.waw_icon name="square" stroke="none" size="4" /></.waw_td_icon>
<.waw_td_icon><.waw_icon name="circuit" stroke="none" size="4" /></.waw_td_icon>
<.waw_td title="Sam">Sam</.waw_td>
<.waw_td title="Smith">Smith</.waw_td>
<.waw_td_icon><.waw_icon name="square-stack-3d-up" stroke="none" size="4" /></.waw_td_icon>
</:tr>
</.waw_table>
"""
          },
          %{
            nom: "Composants",
            code_source: """
<.waw_table>
<.waw_thead>
<.waw_th_icon></.waw_th_icon>
<.waw_th_icon><.waw_icon name="circuit" stroke="none" size="4" /></.waw_th_icon>
<.waw_th sort_key="desc">Name</.waw_th>
<.waw_th sort_key="asc">First Name</.waw_th>
<.waw_th sort_key="desc">Details</.waw_th>
</.waw_thead>
<.waw_tr state="selected">
<.waw_td_icon><.waw_icon name="square-inset-filled" stroke="none" size="4" /></.waw_td_icon>
<.waw_td_icon><.waw_icon name="circuit" stroke="none" size="4" /></.waw_td_icon>
<.waw_td title="Jean">Jean</.waw_td>
<.waw_td title="Dupont">Dupoint</.waw_td>
<.waw_td_icon><.waw_icon name="square-stack-3d-up" stroke="none" size="4" /></.waw_td_icon>
</.waw_tr>
<.waw_tr state="normal">
<.waw_td_icon><.waw_icon name="square" stroke="none" size="4" /></.waw_td_icon>
<.waw_td_icon><.waw_icon name="circuit" stroke="none" size="4" /></.waw_td_icon>
<.waw_td title="Kim">Kim</.waw_td>
<.waw_td title="Léna">Léna</.waw_td>
<.waw_td_icon is_link={true} href="https://www.tag-ip.com/"><.waw_icon name="square-stack-3d-up" stroke="none" size="4" /></.waw_td_icon>
</.waw_tr>
<.waw_tr state="disabled">
<.waw_td_icon><.waw_icon name="square" stroke="none" size="4" /></.waw_td_icon>
<.waw_td_icon><.waw_icon name="circuit" stroke="none" size="4" /></.waw_td_icon>
<.waw_td title="Sam">Sam</.waw_td>
<.waw_td title="Smith">Smith</.waw_td>
<.waw_td_icon><.waw_icon name="square-stack-3d-up" stroke="none" size="4" /></.waw_td_icon>
</.waw_tr>
</.waw_table>
"""
},
        ]
      },
      %{
        sous_categorie: "Onglets",
        module: "Waw.Tabs",
        principal: %{
          nom: "Onglets",
          code_source: """
<.waw_tabs size="lg" align_tab="left">
<.waw_tab active>
Items
</.waw_tab>
<.waw_tab>
Flottes
</.waw_tab>
<.waw_tab disabled>
Instances
</.waw_tab>
<:actions>
<.waw_button label="Rafraîchir" size="sm" variant="outlined" icon="home" />
<div>
<.input id="input-single-search-litle-2" size="sm" type="search" />
</div>
</:actions>
<:content>
<div>Content of tab</div>
</:content>
</.waw_tabs>
"""
        },
        variantes: [
          %{
            nom: "Petite taille",
            code_source: """
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
<div>
<.input id="input-single-search-litle" size="sm" type="search" />
</div>
</:actions>
<:content>
<div>Content of tab</div>
</:content>
</.waw_tabs>
"""
          },
        ]
      },
      %{
        sous_categorie: "Liste de tags",
        module: "Waw.TagList",
        principal: %{
          nom: "Liste de tags",
          code_source: """
<.waw_tag_list title="Flottes">
<:tag>
<.waw_badge id="badge-single-scope-complete" label="value" scope="scope" description="Avec étiquette" color="info-dark">
<:action>
<.waw_button_icon icon="cancel" bg_color="bg-light" />
</:action>
</.waw_badge>
</:tag>
<:tag>
<.waw_badge id="badge-single-scope" label="value" scope="scope" description="Avec étiquette" color="danger" />
</:tag>
<:tag>
<.waw_badge id="badge-single-standard" label="value" description="title" color="info">
<:action>
<.waw_button_icon icon="cancel" />
</:action>
</.waw_badge>
</:tag>
<:tag>
<.waw_badge id="badge-single-default" label="value" color="success" />
</:tag>
<:actions>
<.waw_button_icon icon="add" title="Ajouter un tag" />
</:actions>
</.waw_tag_list>
"""
        },
        variantes: [
        ]
      },
      %{
        sous_categorie: "Info-bulle",
        module: "Waw.Tooltip",
        principal: %{
          nom: "Info-bulle",
          code_source: """
<.tooltip position="top" color="white" content="Information du tooltip" variant="simple" margin="top">
contenu
</.tooltip>
"""
        },
        variantes: [
        ]
      },
      %{
        sous_categorie: "Afficher un trackable",
        module: "Waw.Name",
        principal: %{
          nom: "Trackable",
          code_source: """
<.waw_name value={%{label: "TGP0012", name: "4212TBA", tracker_label: "MD0014", custom_name: "ix35"}}/>
"""
        },
        variantes: [
          %{
            nom: "Avec symbole",
            code_source: """
<.waw_name size="sm" value={%{label: "TGP0012", name: "4212TBA", tracker_label: "MD0014", custom_name: "ix35", trackable_symbol: "moto"}} with_symbol/>
"""
},
        ]
      },
    ],
    "Cartes" => [
      %{
        sous_categorie: "Compte-rendu",
        module: "Waw.Card",
        principal: %{
          nom: "Compte-rendu",
          code_source: """
<.waw_card title="Driver Score Card Synthesis" tooltip_description="Sous forme d'une carte, présente une présentation graphique des trajectoires des véhicules.">
<:section>
<.waw_time_section label="Dernier Maj" value="12:30:05"></.waw_time_section>
<.waw_date_section label="Dernier CR disponible" value="Aujourd'hui"></.waw_date_section>
<.waw_date_section label="1er CR disponible" value="Aujourd'hui"></.waw_date_section>
</:section>
</.waw_card>
"""
        },
        variantes: [
          %{
            nom: "Sélectionnée",
            code_source: """
<.waw_card state="selected" title="Compte-rendu kilométrage journalier" title_icon="file-xls" tooltip_description="Sous forme d'une carte, présente une présentation graphique des trajectoires des véhicules.">
<:section>
<.waw_time_section label="Dernier Maj" value="10:00:19"></.waw_time_section>
<.waw_date_section label="Dernier CR disponible" value="Aujourd'hui"></.waw_date_section>
<.waw_date_section label="1er CR disponible" value="Aujourd'hui"></.waw_date_section>
</:section>
</.waw_card>
"""
},
        ]
      },
      %{
        sous_categorie: "Dashboard",
        module: "Waw.DashboardCard",
        principal: %{
          nom: "Dashboard",
          code_source: """
<.waw_dashboard_card description="Information concernant les véhicules géolocalisés" title="Véhicules géolocalisés">
<div class="grid place-content-center p-4 h-full">
Content
</div>
</.waw_dashboard_card>
"""
        },
        variantes: [
          %{
            nom: "Avec icône",
            code_source: """
<.waw_dashboard_card description="Information concernant la distance parcourue moyenne, journalière, par véhicule" title="Distance parcourue moyenne, journalière, par véhicule" icon="car">
<div class="grid place-content-start p-4 h-full">
Content
</div>
</.waw_dashboard_card>
"""
          },
        ]
      },
      %{
        sous_categorie: "Volume de carburant",
        module: "Waw.FuelCard",
        principal: %{
          nom: "Volume de carburant",
          code_source: """
<.waw_fuel_card value="35" number="1510" title="Consommation totale de carburant de la flotte"/>
"""
        },
        variantes: [
        ]
      },
      %{
  sous_categorie: "Statistique",
        module: "Waw.Stat",
        principal: %{
          nom: "Statistique",
          code_source: """
<.waw_status_card/>
"""
        },
        variantes: [
          %{
            nom: "Loading",
            code_source: """
<.waw_stat loading title="Véhicules géolocalisés"/>
"""
          },
          %{
            nom: "Par défaut",
            code_source: """
<.waw_stat value={100} description="Information concernant les véhicules géolocalisés" title="Véhicules géolocalisés"/>
"""
          },
          %{
            nom: "Avec unité",
            code_source: """
<.waw_stat unit={:kilometer} value={100} description="Information concernant la distance parcourue moyenne, journalière, par véhicule" title="Distance parcourue moyenne, journalière, par véhicule"/>
"""
          },
          %{
            nom: "Avec total",
            code_source: """
<.waw_stat total={251} value={100} title="véhicules géolocalisés"/>
"""
          },
          %{
            nom: "Avec ratio",
            code_source: """
<.waw_stat total={251} value={100} title="véhicules géolocalisés" ratio={:percentage}/>
"""
          },
          %{
            nom: "Avec total et état",
            code_source: """
<.waw_stat status={:success} total={251} value={100} description="Information concernant les véhicules actuellement en mouvement" title="véhicules actuellement en mouvement"/>
"""
          },
          %{
            nom: "Avec intervalle de temps",
            code_source: """
<.waw_stat title="Heure de pointe d'utilisation des véhicules" icon="clock" start_value={~U[2020-05-30 13:52:56Z]} end_value={~U[2020-05-30 14:52:56Z]}/>
"""
          },
          %{
            nom: "Avec durée",
            code_source: """
<.waw_stat unit={:second} value={4210} title="Durée de roulage total des véhicules sur le mois" icon="clock"/>
"""
          },
          %{
            nom: "Complète",
            code_source: """
<.waw_stat unit={:kilometer} value={4210} title="Distance parcourue moyenne, journalière, par véhicule" col={2} icon="circuit" previous_value={90} previous_at={~U[2025-11-20 07:59:45.682352Z]}/>
"""
          },
          %{
            nom: "Complète non-cliquable",
            code_source: """
<.waw_stat status={:danger} value={210} title="véhicules stationnés" icon="truck" variation_symbol={:math} previous_value={90} previous_at={~U[2025-11-20 07:59:45.682356Z]}/>
"""
          },
          %{
            nom: "Status sélectionné",
            code_source: """
<.waw_status_card label="Cinématique" state="selected" icon="steering-wheel"/>
"""
          },
          %{
            nom: "Status désactivé",
            code_source: """
<.waw_status_card label="Balise GPS" state="disabled" icon="tracker"/>
"""
          },
          %{
            nom: "Status pour CR",
            code_source: """
<.waw_status_card label="CR véhicule" state="exception" icon="sign-out"/>
"""
          },
        ]
      },
    ],
    "Dates et heures" => [
      %{
  sous_categorie: "Dates",
        module: "Waw.Text.Dates",
        principal: %{
          nom: "Date",
          code_source: """
<.date value={~U[2025-11-20 08:19:56.285343Z]} format={:medium}/>
"""
        },
        variantes: [
          %{
            nom: "Date et heure",
            code_source: """
<.date_time value={~U[2025-11-20 08:21:11.635563Z]} format={:medium}/>
"""
},
        ]
      },
      %{
        sous_categorie: "Intervalle de temps",
        module: "Waw.Text.Dates",
        principal: %{
          nom: "Intervalle",
          code_source: """
<.interval format={:medium} from={~D[2025-11-20]} to={~D[2025-11-23]}/>
"""
        },
        variantes: [
          %{
            nom: "Dates et heures",
            sous_variantes: [
              %{
                nom: "Medium",
                code_source: """
<.interval from={~U[2025-12-03 10:26:07.956246Z]} to={~U[2025-12-03 11:42:16.956251Z]}/>
"""
              },
              %{
                nom: "Short",
                code_source: """
<.interval format={:short} from={~U[2025-12-03 10:26:07.956258Z]} to={~U[2025-12-03 11:42:16.956260Z]}/>
"""
              },
              %{
                nom: "Long",
                code_source: """
<.interval format={:long} from={~U[2025-12-03 10:26:07.956263Z]} to={~U[2025-12-03 11:42:16.956264Z]}/>
"""
              },
            ]
          },
          %{
            nom: "Dates",
            sous_variantes: [
              %{
                nom: "Par défaut",
                code_source: """
<.interval from={~D[2025-12-03]} to={~D[2025-12-06]}/>
"""
              },
              %{
                nom: "Par mois",
                code_source: """
<.interval from={~D[2025-12-03]} to={~D[2026-01-02]} style={:month}/>
"""
              },
              %{
                nom: "Par mois et jours",
                code_source: """
<.interval from={~D[2025-12-03]} to={~D[2025-12-31]} style={:month_and_day}/>
"""
              },
              %{
                nom: "Par an et mois",
                code_source: """
<.interval from={~D[2025-12-03]} to={~D[2026-12-26]} style={:year_and_month}/>
"""
              },
            ]
          },
          %{
            nom: "Heures",
            sous_variantes: [
              %{
                nom: "Par défaut",
                code_source: """
<.interval from={~T[10:26:07.956275]} to={~T[11:29:16.956277]}/>
"""
              },
              %{
                nom: "Short",
                code_source: """
<.interval format={:short} from={~T[10:26:07.956288]} to={~T[11:29:16.956289]}/>
"""
              },
              %{
                nom: "Flex",
                code_source: """
<.interval format={:short} from={~T[10:26:07.956291]} to={~T[11:29:16.956292]} style={:flex}/>
"""
              },
              %{
                nom: "Time",
                code_source: """
<.interval format={:short} from={~T[10:26:07.956294]} to={~T[11:29:16.956295]} style={:time}/>
"""
              },
              %{
                nom: "Zone",
                code_source: """
<.interval from={~T[10:26:07.956296]} to={~T[11:29:16.956297]}/>
"""
              },
            ]
          },
        ]
      },
      %{
  sous_categorie: "Relatives",
        module: "Waw.Text.Dates",
        principal: %{
          nom: "Temps relatif",
          code_source: """
<.relative_time value={~U[2025-11-21 08:24:47.338059Z]} ref={~U[2025-11-20 08:24:47.338092Z]}/>
"""
        },
        variantes: [
        ]
      },
      %{
        sous_categorie: "Heures",
        module: "Waw.Text.Dates",
        principal: %{
          nom: "Heure",
          code_source: """
<.time value={~U[2025-11-20 08:27:09.103149Z]} format={:medium}/>
"""
        },
        variantes: [
        ]
      },
    ],
    "Formulaire" => [
    ],
    "Mises en page" => [
      %{
        sous_categorie: "Mise en page des formulaires",
        module: "WawShowcaseWeb.Components.Layout",
        principal: %{
          nom: "Formulaire",
          code_source: """
<.forms>
<:header>
Titre
</:header>
<:grid_content>
<.grid grid_cols="cols-1">
<.input id="input-single-text" size="lg" type="text" placeholder="Placeholder" label="Label" required tooltip_is_visible>
<:tooltip_block>
<.tooltip position="top" color="white" content="Contenu de l'info-bulle" variant="arrow">
(**)
</.tooltip>
</:tooltip_block>
</.input>
<.input id="input-single-textarea" label="Label" size="lg" type="text" placeholder="Placeholder" text_type="textarea"/>
</.grid>
</:grid_content>
<:actions>
<.waw_button label="Valider" size="md" type="submit" full_width />
<.waw_button label="Annuler" size="md" type="cancel" full_width />
</:actions>
</.forms>
"""
        },
        variantes: [
          %{
            nom: "Plusieurs sections",
            code_source: """
<.forms>
<:header>
Titre
</:header>
<:grid_content>
<.grid>
<.input id="input-single-text-2" size="lg" type="text" placeholder="Identifiant" label="Identifiant" required tooltip_is_visible>
<:tooltip_block>
<.tooltip position="top" color="white" content="L'identifiant doit être un trigramme" variant="arrow">
(**)
</.tooltip>
</:tooltip_block>
</.input>
<.input id="input-single-text-3" label="Nom" size="lg" type="text" placeholder="Nom"/>
</.grid>
<.grid grid_cols="cols-2">
<.input id="input-single-email" label="Email" size="lg" type="text" placeholder="name@tag_ip.com" text_type="email"/>
<.input id="input-single-textarea-2" label="Note" size="lg" type="text" placeholder="Placeholder" text_type="textarea"/>
</.grid>
<.grid grid_cols="cols-3">
<.input id="input-single-select" label="Type" size="lg" type="select">
<option>option 1</option>
<option>option 2</option>
</.input>
<.input id="input-single-time" label="Heure" size="lg" type="time" value="12:45"/>
<.input id="input-single-date" label="Date" size="lg" type="date"/>
</.grid>
</:grid_content>
<:actions>
<.waw_button label="Valider" size="md" type="submit" full_width />
<.waw_button label="Annuler" size="md" type="cancel" full_width />
</:actions>
</.forms>
"""
          },
        ]
      },
      %{
        sous_categorie: "Mise en page avec 2 sections",
        module: "WawShowcaseWeb.Components.Layout",
        principal: %{
          nom: "Layout 2 sections",
          code_source: """
<.layout_2s>
<:header>
<.header  title="Admin" background="light" logo="tag-ip" />
</:header>
<:section_header>
<div class="w-96">
<.waw_dl>
<.waw_definition text_align="left" term="Identifiant" description="DEMO" />
<.waw_definition text_align="left" term="Nom" description="Demonstration">
<:actions>
<.waw_link_icon size="sm" state="checked" icon="square-and-pencil"/>
</:actions>
</.waw_definition>
<.waw_definition text_align="left" term="Note" description="Organisation pour les Demos">
<:actions>
<.waw_link_icon size="sm" state="checked" icon="square-and-pencil"/>
</:actions>
</.waw_definition>
</.waw_dl>
</div>
</:section_header>
<:main>
<div class="m-4">
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
<.waw_button label="Rafraîchir" size="sm" icon="arrow-triangle-2-circlepath-refresh" icon_position="left" />
<.input id="input-single-search-litle" size="sm" type="search"/>
</:actions>
<:content>
<div>
<.waw_table>
<:thead>
<.waw_th>Name</.waw_th>
<.waw_th>First Name</.waw_th>
<.waw_th>Voir</.waw_th>
</:thead>
<:tr state="selected">
<.waw_td title="Jean">Jean</.waw_td>
<.waw_td title="Dupont">Dupoint</.waw_td>
<.waw_td_icon is_link={true} href="https://www.tag-ip.com/"><.waw_icon name="arrow-small-right" stroke="none" size="4" /></.waw_td_icon>
</:tr>
<:tr state="normal">
<.waw_td title="Kim">Kim</.waw_td>
<.waw_td title="Léna">Léna</.waw_td>
<.waw_td_icon is_link={true} href="https://www.tag-ip.com/"><.waw_icon name="arrow-small-right" stroke="none" size="4" /></.waw_td_icon>
</:tr>
<:tr state="disabled">
<.waw_td title="Sam">Sam</.waw_td>
<.waw_td title="Smith">Smith</.waw_td>
<.waw_td_icon><.waw_icon name="arrow-small-right" stroke="none" size="4" /></.waw_td_icon>
</:tr>
</.waw_table>
</div>
</:content>
</.waw_tabs>
</div>
</:main>
</.layout_2s>
"""
        },
        variantes: [
        ]
      },
      %{
        sous_categorie: "Mise en page avec 3 sections",
        module: "WawShowcaseWeb.Components.Layout",
        principal: %{
          nom: "Layout 3 sections",
          code_source: """
<.layout_3s>
<:header>
<.header title="Démo" background="dark">
<:tab id="realtime" title="Temps réel" active={true} />
<:tab id="vehicle_cr" title="CR véhicule" disabled={true} />
<:tab id="fleet_cr" title="CR flottes" />
</.header>
</:header>
<:subheader>
<.subheader>
<:breadcrumb>
<.nav_breadcrumb>
<.waw_icon name="home-fill" size="4" stroke="none" />
</.nav_breadcrumb>
</:breadcrumb>
<:breadcrumb>
<.nav_breadcrumb>2MI</.nav_breadcrumb>
</:breadcrumb>
<:breadcrumb>
<.nav_breadcrumb>Coursiers</.nav_breadcrumb>
</:breadcrumb>
<:breadcrumb>
<.nav_breadcrumb active>Vue globale</.nav_breadcrumb>
</:breadcrumb>
<:right>
<.interval
format={:short}
to={~U[2023-09-22 07:29:23.707953Z]}
from={~U[2023-09-22 06:13:14.707953Z]}
/>
<.live_search name="test">
</.live_search>
</:right>
</.subheader>
</:subheader>
<:left_panel>
<.waw_panel_header title="Title"/>
<.waw_list_header>
<:left>
<.waw_button_icon icon="caret-down" />
</:left>
<:center>
<.waw_button_icon icon="caret-down" />
</:center>
<:right>
<.waw_button_icon icon="caret-up" />
<.waw_button_icon icon="caret-down" />
<.waw_button_icon icon="caret-up" />
</:right>
</.waw_list_header>
<.ul>
<.li acronym="T" state="selected" title="Tag-ip">Tag-ip</.li>
<.li acronym="2" title="2mi">2mi</.li>
<.li acronym="H" title="Holcim">Holcim</.li>
<.li icon="lock-close-fill" lock_status="locked" battery_number="50" connexion_status="low_activity">item 15</.li>
<.li icon="person-fill" state="alert" battery_number="30" connexion_status="offline">item 8</.li>
</.ul>
</:left_panel>
<:main>
<div id="card" class="mx-2 my-2">
<.waw_card state="selected" title="Compte-rendu kilométrage journalier" tooltip_description="Sous forme d'une carte, présente une présentation graphique des trajectoires des véhicules." title_icon="file-xls">
<:section>
<.waw_time_section label="Dernier Maj" value="10:00:19"></.waw_time_section>
<.waw_date_section label="Dernier CR disponible" value="Aujourd'hui"></.waw_date_section>
<.waw_date_section label="1er CR disponible" value="Aujourd'hui"></.waw_date_section>
</:section>
</.waw_card>
</div>
<div id="card-2" class="mx-2 my-2">
<.waw_card title="Driver Score Card Synthesis" tooltip_description="Sous forme d'une carte, présente une présentation graphique des trajectoires des véhicules.">
<:section>
<.waw_time_section label="Dernier Maj" value="13:30:05"></.waw_time_section>
<.waw_date_section label="Dernier CR disponible" value="Aujourd'hui"></.waw_date_section>
<.waw_date_section label="1er CR disponible" value="Aujourd'hui"></.waw_date_section>
</:section>
</.waw_card>
</div>
</:main>
<:button_section>
<.input id="date-input" name="selected_date" type="date" size="md" />
</:button_section>
<:details>
<.waw_table>
<:thead>
<.waw_th>Name</.waw_th>
<.waw_th>First Name</.waw_th>
<.waw_th>Voir</.waw_th>
</:thead>
<:tr state="selected">
<.waw_td title="Jean">Jean</.waw_td>
<.waw_td title="Dupont">Dupoint</.waw_td>
<.waw_td_icon is_link={true} href="https://www.tag-ip.com/"><.waw_icon name="arrow-small-right" stroke="none" size="4" /></.waw_td_icon>
</:tr>
<:tr state="normal">
<.waw_td title="Kim">Kim</.waw_td>
<.waw_td title="Léna">Léna</.waw_td>
<.waw_td_icon is_link={true} href="https://www.tag-ip.com/"><.waw_icon name="arrow-small-right" stroke="none" size="4" /></.waw_td_icon>
</:tr>
<:tr state="disabled">
<.waw_td title="Sam">Sam</.waw_td>
<.waw_td title="Smith">Smith</.waw_td>
<.waw_td_icon><.waw_icon name="arrow-small-right" stroke="none" size="4" /></.waw_td_icon>
</:tr>
</.waw_table>
</:details>
<:right_panel>
<.waw_panel_header title="Title"/>
<.ul>
<.li acronym="T" state="selected" title="Tag-ip">Tag-ip</.li>
<.li acronym="2" title="2mi">2mi</.li>
<.li acronym="H" title="Holcim">Holcim</.li>
</.ul>
</:right_panel>
</.layout_3s>
"""
        },
        variantes: [
        ]
      },
    ],
    "Modals" => [
      %{
        sous_categorie: "Modal pour un filtre",
        module: "Waw.Modal",
        principal: %{
          nom: "Modal filtre",
          code_source: """
<div>
    <.waw_button type="button" phx-click={show_modal("filter-modal-single-modal")} label="Ouvrir Modal" />
  </div>
"""
        },
        variantes: [
        ]
      },
      %{
        sous_categorie: "Modal pour un formulaire",
        module: "Waw.Modal",
        principal: %{
          nom: "Modal formulaire",
          code_source: """
<div>
<.waw_button type="button" phx-click={show_modal("forms-modal-single-modal")} label="Ouvrir Modal" />
</div>
"""
        },
        variantes: [
        ]
      },
    ],
    "Modèles" => [
      %{
        sous_categorie: "Conteneur de liste de blocs",
        module: "Waw.BlockListContainer",
        principal: %{
          nom: "Conteneur de blocs",
          code_source: """
<.waw_block_list_container>
<:block multicolumn={false}>
<.waw_block_title label="Bloc 1"/>
<.waw_definition text_align="left" term="term" description="description" has_actions={false} />
<.waw_definition text_align="left" term="term" description="description" has_actions={false} />
<.waw_definition text_align="left" term="term" description="description" has_actions={false} />
<.waw_definition text_align="left" term="term" description="description" has_actions={false} />
</:block>
<:block multicolumn={false}>
<.waw_block_title label="Bloc 2"/>
<.waw_definition text_align="left" term="term" description="description" has_actions={false} />
<.waw_definition text_align="left" term="term" description="description" has_actions={false} />
<.waw_definition text_align="left" term="term" description="description" has_actions={false} />
<.waw_definition text_align="left" term="term" description="description" has_actions={false} />
</:block>
<:block multicolumn={false}>
<.waw_block_title label="Bloc 3"/>
<.waw_definition text_align="left" term="term" description="description" has_actions={false} />
<.waw_definition text_align="left" term="term" description="description" has_actions={false} />
<.waw_definition text_align="left" term="term" description="description" has_actions={false} />
<.waw_definition text_align="left" term="term" description="description" has_actions={false} />
</:block>
<:block multicolumn={true}>
<.waw_block_title label="Bloc 4"/>
<.waw_block_title label="Sous bloc 1"/>
<.waw_block_list_container>
<:block multicolumn={false}>
<.waw_definition text_align="left" term="term" description="description" has_actions={false} />
<.waw_definition text_align="left" term="term" description="description" has_actions={false} />
<.waw_definition text_align="left" term="term" description="description" has_actions={false} />
<.waw_definition text_align="left" term="term" description="description" has_actions={false} />
<.waw_definition text_align="left" term="term" description="description" has_actions={false} />
</:block>
<:block multicolumn={false}>
<.waw_definition text_align="left" term="term" description="description" has_actions={false} />
<.waw_definition text_align="left" term="term" description="description" has_actions={false} />
<.waw_definition text_align="left" term="term" description="description" has_actions={false} />
<.waw_definition text_align="left" term="term" description="description" has_actions={false} />
</:block>
</.waw_block_list_container>
<.waw_block_title label="Sous bloc 2"/>
<.waw_block_list_container>
<:block multicolumn={false}>
<.waw_definition text_align="left" term="term" description="description" has_actions={false} />
<.waw_definition text_align="left" term="term" description="description" has_actions={false} />
<.waw_definition text_align="left" term="term" description="description" has_actions={false} />
<.waw_definition text_align="left" term="term" description="description" has_actions={false} />
</:block>
</.waw_block_list_container>
</:block>
</.waw_block_list_container>
"""
        },
        variantes: [
        ]
      },
      %{
        sous_categorie: "Header et Footer fixes",
        module: "WawShowcaseWeb.Components.Layout",
        principal: %{
          nom: "Header et Footer",
          code_source: """
<.fixed_header_footer>
<:header>
<.header title="Démo" log_out_url="" profile_url="">
<:nav>
<.navbar active={false}>
Temps réel
</.navbar>
<.navbar active={true}>
CR véhicule
</.navbar>
<.navbar active={false} disabled={true}>
CR flottes
</.navbar>
</:nav>
<:actions>
<.link>
<.waw_icon name="bell-fill" size="4" />
</.link>
<.link>
<.waw_icon name="circle-grid-3x3" size="4" />
</.link>
<.link>
<.waw_icon name="person-fill" size="4" />
</.link>
</:actions>
</.header>
</:header>
<:main>
<.waw_dashboard>
<:section title="BOB">
<.waw_stat
title="véhicules en mouvement"
value={51}
total={251}
previous_value={100}
variation_symbol={:math}
previous_at={DateTime.utc_now()}
status={:success}
col={2}
/>
<.waw_stat
title="véhicules stationnés"
value={25}
total={251}
previous_value={10}
variation_symbol={:math}
status={:danger}
col={2}
/>
</:section>
</.waw_dashboard>
</:main>
<:footer>
<.footer copyright_year={DateTime.utc_now().year} />
</:footer>
</.fixed_header_footer>
"""
        },
        variantes: [
        ]
      },
      %{
  sous_categorie: "Element structuré",
        module: "Waw.IconTitleAction",
        principal: %{
          nom: "Élément structuré",
          code_source: """
<.waw_icon_title_action>
<:label>
label
</:label>
</.waw_icon_title_action>
"""
        },
        variantes: [
          %{
            nom: "Avec icône",
            code_source: """
<.waw_icon_title_action>
  <:icon>
    <.waw_icon name="truck" />
  </:icon>
  <:label>
  label
  </:label>
</.waw_icon_title_action>
"""
          },
          %{
            nom: "Complet",
            code_source: """
<.waw_icon_title_action>
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
</.waw_icon_title_action>
"""
},
        ]
      },
    ],
    "Pages" => [
      %{
        sous_categorie: "Page 404",
        module: "Waw.PageError",
        principal: %{
  nom: "Page 404",
          code_source: """
<.waw_page_error url="https://tag-ip.com/">
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
"""
        },
        variantes: [
        ]
      },
    ],
    "Texte et Nombres" => [
      %{
        sous_categorie: "Devises",
        module: "Waw.Text.Currency",
        principal: %{
  nom: "Devise",
          code_source: """
<.currency value={123} currency="USD"/>
"""
        },
        variantes: [
        ]
      },
      %{
  sous_categorie: "Distance",
        module: "Waw.Text.Distance",
        principal: %{
          nom: "Distance",
          code_source: """
<.distance unit={:meter} value={10000}/>
"""
        },
        variantes: [
          %{
            nom: "En mètre",
            code_source: """
<.distance unit={:meter} value={10000}/>
"""
          },
          %{
            nom: "En kilomètre",
            code_source: """
<.distance unit={:kilometer} value={10000}/>
"""
},
        ]
      },
      %{
        sous_categorie: "Valeur nil",
        module: "Waw.Text.Number",
        principal: %{
          nom: "Valeur nil",
          code_source: """
<.number unit={nil} value={nil}/>
"""
        },
        variantes: [
        ]
      },
      %{
        sous_categorie: "Nombre",
        module: "Waw.Text.Number",
        principal: %{
          nom: "Nombre",
          code_source: """
<.number unit={nil} value={12000}/>
"""
        },
        variantes: [
        ]
      },
      %{
        sous_categorie: "Volume",
        module: "Waw.Text.Number",
        principal: %{
          nom: "Volume",
          code_source: """
<.number unit={:liter} value={10000}/>
"""
        },
        variantes: [
        ]
      },
      %{
        sous_categorie: "Texte",
        module: "Waw.Text.Text",
        principal: %{
  nom: "Texte",
          code_source: """
<.text value="Exemple de texte"/>
"""
        },
        variantes: [
        ]
      },
    ],
  }

  @doc """
  Retourne tous les composants organisés par catégorie.
  """
  def get_all_components, do: @ui_components

  @doc """
  Retourne les composants d'une catégorie spécifique.
  """
  def get_components_by_category(category), do: Map.get(@ui_components, category, [])

  @doc """
  Retourne un composant spécifique par catégorie et sous-catégorie.
  """
  def get_component(category, sous_categorie) do
    @ui_components
    |> Map.get(category, [])
    |> Enum.find(&(&1.sous_categorie == sous_categorie))
  end
end
