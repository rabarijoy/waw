// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//
// If you have dependencies that try to import CSS, esbuild will generate a separate `app.css` file.
// To load it, simply add a second `<link>` to your `root.html.heex` file.

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import {hooks as colocatedHooks} from "phoenix-colocated/waw_showcase"
import topbar from "../vendor/topbar"

// MapLibre GL JS for maps
import maplibregl from "maplibre-gl"
import "maplibre-gl/dist/maplibre-gl.css"

// Map Hook for MapLibre GL JS integration avec OpenFreeMap
const MapHook = {
  mounted() {
    const vehicules = JSON.parse(this.el.dataset.vehicules || "[]")
    const selectedId = this.el.dataset.selected || null

    // Initialize map avec style OpenFreeMap (gratuit et sans limite)
    // Style Positron: simple, minimaliste, rapide
    const map = new maplibregl.Map({
      container: this.el,
      style: 'https://tiles.openfreemap.org/styles/positron',
      center: [47.5079, -18.8792], // [longitude, latitude] Antananarivo, Madagascar
      zoom: 11 // Niveau de zoom pour voir la ville
    })

    // Ajouter les contrôles de navigation (zoom +/-)
    map.addControl(new maplibregl.NavigationControl(), 'top-right')

    // Attendre que la carte soit chargée avant d'ajouter les marqueurs
    map.on('load', () => {
      // Add markers for each vehicle
      const markers = {}
      vehicules.forEach(vehicule => {
        // Déterminer la couleur selon le statut
        let color = '#3b82f6' // Bleu par défaut (Maintenance)
        if (vehicule.statut === 'Actif') {
          color = '#10b981' // Vert
        } else if (vehicule.statut === 'Alerte') {
          color = '#f59e0b' // Orange
        } else if (vehicule.statut === 'Maintenance') {
          color = '#3b82f6' // Bleu
        }

        // Créer un élément visuel personnalisé pour le marqueur
        const el = document.createElement('div')
        el.className = 'marker'
        el.style.width = '32px'
        el.style.height = '32px'
        el.style.borderRadius = '50%'
        el.style.backgroundColor = color
        el.style.border = '3px solid white'
        el.style.cursor = 'pointer'
        el.style.boxShadow = '0 2px 4px rgba(0, 0, 0, 0.3)'
        el.title = `${vehicule.marque} ${vehicule.modele}`

        // Créer le marqueur MapLibre avec l'élément personnalisé
        const marker = new maplibregl.Marker({ element: el })
          .setLngLat([vehicule.lng, vehicule.lat]) // [longitude, latitude]
          .addTo(map)

        // Ajouter un écouteur de clic sur le marqueur
        el.addEventListener('click', () => {
          this.pushEvent("select_vehicule", {id: vehicule.id})
        })

        markers[vehicule.id] = marker
      })

      this.markers = markers
      this.lastSelectedId = selectedId
    })

    this.map = map
  },

  updated() {
    const vehicules = JSON.parse(this.el.dataset.vehicules || "[]")
    const selectedId = this.el.dataset.selected || null

    // Only update if the selected vehicle changed
    if (this.lastSelectedId !== selectedId && this.markers && this.map) {
      vehicules.forEach(vehicule => {
        if (this.markers[vehicule.id]) {
          // Déterminer la couleur selon le statut
          let color = '#3b82f6' // Bleu par défaut
          if (vehicule.statut === 'Actif') {
            color = '#10b981' // Vert
          } else if (vehicule.statut === 'Alerte') {
            color = '#f59e0b' // Orange
          } else if (vehicule.statut === 'Maintenance') {
            color = '#3b82f6' // Bleu
          }

          const markerElement = this.markers[vehicule.id]._element
          if (markerElement) {
            markerElement.style.backgroundColor = color
          }
          
          // Centrer la carte sur le véhicule sélectionné avec animation
          if (vehicule.id === selectedId) {
            this.map.flyTo({
              center: [vehicule.lng, vehicule.lat],
              zoom: 13,
              duration: 1000 // Animation de 1 seconde
            })
          }
        }
      })
      
      this.lastSelectedId = selectedId
    }
  },

  destroyed() {
    // Nettoyage: détruire la carte pour libérer la mémoire
    if (this.map) {
      this.map.remove()
    }
  }
}

// Component Inspector Hook - détecte le clic droit et identifie les composants
// Fonction pour afficher le menu flottant
function showComponentMenu(component, x, y, targetElement) {
  console.log("Showing component menu:", component, x, y, "at", x, y)
  // Fermer le menu existant s'il y en a un
  closeComponentMenu()
  
  // Créer le menu
  const menu = document.createElement("div")
  menu.id = "component-inspector-menu"
  menu.className = "component-inspector-menu"
  menu.style.position = "fixed"
  menu.style.left = `${x}px`
  menu.style.top = `${y}px`
  menu.style.zIndex = "10000"
  menu.style.pointerEvents = "auto"
  
  console.log("Menu created, adding to DOM")
  
  // Titre
  const title = document.createElement("div")
  title.className = "component-inspector-title"
  title.textContent = component.nom || "Composant inconnu"
  menu.appendChild(title)
  
  // Sous-titre
  if (component.type && component.sous_categorie) {
    const subtitle = document.createElement("div")
    subtitle.className = "component-inspector-subtitle"
    subtitle.textContent = `${component.type} > ${component.sous_categorie}`
    menu.appendChild(subtitle)
  }
  
  // Boutons
  const buttonsContainer = document.createElement("div")
  buttonsContainer.className = "component-inspector-buttons"
  
  // Bouton "Copier le code source"
  const copyButton = document.createElement("button")
  copyButton.className = "component-inspector-button"
  copyButton.textContent = "Copier le code source"
  copyButton.addEventListener("click", () => {
    if (component.code_source) {
      navigator.clipboard.writeText(component.code_source).then(() => {
        closeComponentMenu()
      })
    }
  })
  buttonsContainer.appendChild(copyButton)
  
  // Bouton "Inspecter l'élément"
  const inspectButton = document.createElement("button")
  inspectButton.className = "component-inspector-button"
  inspectButton.textContent = "Inspecter l'élément"
  inspectButton.addEventListener("click", () => {
    // Sélectionner l'élément dans les outils de développement
    if (targetElement) {
      targetElement.scrollIntoView({ behavior: "smooth", block: "center" })
      targetElement.style.outline = "2px solid #3b82f6"
      targetElement.style.outlineOffset = "2px"
      
      // Essayer d'utiliser les DevTools pour inspecter l'élément
      // Note: On ne peut pas forcer l'ouverture des DevTools pour des raisons de sécurité
      // Mais on peut essayer de sélectionner l'élément si les DevTools sont déjà ouverts
      
      // Pour Chrome/Edge: utiliser window.inspect() si disponible (nécessite DevTools ouverts)
      if (typeof window.inspect === 'function') {
        try {
          window.inspect(targetElement)
        } catch (e) {
          console.log("inspect() not available, DevTools may not be open")
        }
      }
      
      // Pour Firefox: utiliser $0 dans la console (nécessite DevTools ouverts)
      if (window.console && console.log) {
        console.log("Element to inspect:", targetElement)
        console.log("To inspect this element, open DevTools and run: $0 = arguments[0]", targetElement)
      }
      
      // Afficher un message à l'utilisateur
      const message = document.createElement("div")
      message.textContent = "Ouvrez les outils de développement (F12) pour inspecter cet élément"
      message.style.cssText = "position: fixed; top: 20px; right: 20px; background: #3b82f6; color: white; padding: 12px 16px; border-radius: 8px; z-index: 10001; box-shadow: 0 4px 12px rgba(0,0,0,0.15);"
      document.body.appendChild(message)
      setTimeout(() => {
        message.remove()
      }, 3000)
      
      setTimeout(() => {
        targetElement.style.outline = ""
      }, 3000)
    }
    closeComponentMenu()
  })
  buttonsContainer.appendChild(inspectButton)
  
  // Bouton "Voir dans le Storybook"
  const storybookButton = document.createElement("button")
  storybookButton.className = "component-inspector-button"
  storybookButton.textContent = "Voir dans le Storybook"
  storybookButton.addEventListener("click", () => {
    // Ouvrir le Storybook dans un nouvel onglet
    window.open("https://waw.tag-ip.xyz/", "_blank")
    closeComponentMenu()
  })
  buttonsContainer.appendChild(storybookButton)
  
  menu.appendChild(buttonsContainer)
  document.body.appendChild(menu)
  
  console.log("Menu added to DOM, menu element:", menu)
  
  // Ajuster la position si le menu dépasse de l'écran
  const rect = menu.getBoundingClientRect()
  console.log("Menu rect:", rect)
  if (rect.right > window.innerWidth) {
    menu.style.left = `${window.innerWidth - rect.width - 10}px`
  }
  if (rect.bottom > window.innerHeight) {
    menu.style.top = `${window.innerHeight - rect.height - 10}px`
  }
  
  // Forcer le menu à être visible
  menu.style.display = "block"
  menu.style.visibility = "visible"
  menu.style.opacity = "1"
  
  // Fermer le menu si on clique en dehors
  const closeOnClickOutside = (e) => {
    if (!menu.contains(e.target)) {
      closeComponentMenu()
      document.removeEventListener("click", closeOnClickOutside)
    }
  }
  setTimeout(() => {
    document.addEventListener("click", closeOnClickOutside)
  }, 0)
  
  // Fermer le menu si on appuie sur Échap
  const closeOnEscape = (e) => {
    if (e.key === "Escape") {
      closeComponentMenu()
      document.removeEventListener("keydown", closeOnEscape)
    }
  }
  document.addEventListener("keydown", closeOnEscape)
}

// Fonction pour fermer le menu
function closeComponentMenu() {
  const menu = document.getElementById("component-inspector-menu")
  if (menu) {
    menu.remove()
  }
}

// Fonction helper pour extraire les attributs d'un élément DOM
function extractAttributes(element) {
  const attributes = {}
  
  if (element.attributes) {
    for (let i = 0; i < element.attributes.length; i++) {
      const attr = element.attributes[i]
      // Inclure les classes CSS et les data-attributes car ils sont importants pour identifier les composants Waw
      if (!attr.name.startsWith("phx-") && 
          !attr.name.startsWith("data-phx-")) {
        attributes[attr.name] = attr.value
      }
    }
  }
  
  return attributes
}

// Stocker la référence à l'élément cible pour l'utiliser dans la réponse
// Utiliser un Map pour stocker plusieurs cibles avec leurs coordonnées
const inspectTargets = new Map()

// Initialiser l'inspecteur de composants directement sur document
// Utiliser capture: true pour intercepter l'événement avant qu'il ne soit traité par le navigateur
function initComponentInspector() {
  // Éviter d'ajouter plusieurs listeners
  if (window.componentInspectorListenerAdded) {
    console.log("Component inspector already initialized")
    return
  }
  
  console.log("Initializing component inspector")
  
  // Écouter l'événement contextmenu sur document avec capture pour intercepter avant le navigateur
  const contextMenuHandler = (event) => {
    // Empêcher le menu contextuel du navigateur IMMÉDIATEMENT
    event.preventDefault()
    event.stopPropagation()
    event.stopImmediatePropagation()
    
    const clientX = event.clientX
    const clientY = event.clientY
    
    // Vérifier que event.target correspond bien à l'élément sous la souris
    const elementFromPoint = document.elementFromPoint(clientX, clientY)
    const elementsStack = document.elementsFromPoint
      ? document.elementsFromPoint(clientX, clientY)
      : [elementFromPoint].filter(Boolean)
    
    console.log("Context menu event captured and prevented", {
      eventTarget: event.target,
      elementFromPoint,
      clientX,
      clientY,
      elementsStack
    })
    
    // Si elementFromPoint est différent de event.target, on privilégie elementFromPoint
    // (cas d'overlays, de wrappers ou de captures d'événements).
    let targetElement = event.target
    if (
      elementFromPoint &&
      elementFromPoint !== event.target &&
      elementFromPoint.tagName &&
      !["html", "body"].includes(elementFromPoint.tagName.toLowerCase())
    ) {
      console.log("🔁 Remplacement de event.target par elementFromPoint pour l'inspection")
      targetElement = elementFromPoint
    }
    
    const domPath = []
    let current = targetElement
    
    // Remonter la hiérarchie pour construire un chemin DOM (debug uniquement)
    while (current && current !== document.body && current !== document.documentElement) {
      const tag = current.tagName.toLowerCase()
      const attributes = extractAttributes(current)
      
      domPath.push({
        tag: tag,
        attributes: attributes
      })
      
      current = current.parentElement
    }
    
    // Chercher le parent porteur de l'attribut data-component (mapping explicite)
    let componentElement = targetElement
    let componentName = null
    while (
      componentElement &&
      componentElement !== document.body &&
      componentElement !== document.documentElement
    ) {
      const compAttr = componentElement.getAttribute("data-component")
      if (compAttr) {
        componentName = compAttr
        break
      }
      componentElement = componentElement.parentElement
    }
    
    console.log("Nearest data-component ancestor:", {
      element: componentElement,
      componentName
    })
    
    // Chercher l'élément porteur de la métadonnée LiveView (data-phx-loc) – plus utilisé pour la résolution,
    // mais gardé pour debug si nécessaire.
    let sourceElement = targetElement
    let sourceLoc = null
    while (
      sourceElement &&
      sourceElement !== document.body &&
      sourceElement !== document.documentElement
    ) {
      const locAttr = sourceElement.getAttribute("data-phx-loc")
      if (locAttr) {
        const parsed = parseInt(locAttr, 10)
        if (!Number.isNaN(parsed)) {
          sourceLoc = parsed
          break
        }
      }
      sourceElement = sourceElement.parentElement
    }

    console.log("Source element for HEEx lookup (debug only):", { sourceElement, sourceLoc })

    // Trouver le LiveView actif et envoyer l'événement avec les coordonnées
    const liveViewEl = document.querySelector('[data-phx-main]')
    console.log("LiveView element:", liveViewEl)
    
    if (liveViewEl) {
      // Préparer les données de l'événement
      const eventData = {
        tag: targetElement.tagName.toLowerCase(),
        attributes: extractAttributes(targetElement),
        dom_path: domPath,
        x: clientX,
        y: clientY,
        loc: sourceLoc,
        component: componentName
      }
      
      // Stocker la référence à l'élément cible avec les coordonnées comme clé
      const key = `${eventData.x}_${eventData.y}`
      inspectTargets.set(key, targetElement)
      
      // Créer un élément temporaire avec phx-click pour envoyer l'événement
      const tempElement = document.createElement("div")
      tempElement.style.display = "none"
      tempElement.setAttribute("phx-click", "inspect_component")
      tempElement.setAttribute("phx-value-tag", eventData.tag)
      tempElement.setAttribute("phx-value-x", String(eventData.x))
      tempElement.setAttribute("phx-value-y", String(eventData.y))
      if (eventData.loc != null) {
        tempElement.setAttribute("phx-value-loc", String(eventData.loc))
      }
      if (eventData.component) {
        tempElement.setAttribute("phx-value-component", eventData.component)
      }
      // Utiliser "dom_path" (underscore) car Phoenix convertit les tirets en underscores
      tempElement.setAttribute("phx-value-dom_path", JSON.stringify(eventData.dom_path))
      tempElement.setAttribute("phx-value-attributes", JSON.stringify(eventData.attributes))
      
      console.log("📤 [DEBUG] Envoi événement inspect_component avec:", {
        tag: eventData.tag,
        x: eventData.x,
        y: eventData.y,
        dom_path_length: eventData.dom_path.length
      })
      liveViewEl.appendChild(tempElement)
      
      // Déclencher le clic programmatiquement
      try {
        tempElement.click()
        // Afficher un menu temporaire en attendant la réponse
        showComponentMenu({
          nom: "Chargement...",
          type: null,
          sous_categorie: null,
          code_source: null
        }, clientX, clientY, targetElement)
        
        // Nettoyer l'élément temporaire après un court délai
        setTimeout(() => {
          if (tempElement.parentNode) {
            tempElement.parentNode.removeChild(tempElement)
          }
        }, 1000)
      } catch (error) {
        console.error("Error triggering phx-click:", error)
        // Afficher un menu de base en cas d'erreur
        showComponentMenu({
          nom: "Composant non identifié",
          type: null,
          sous_categorie: null,
          code_source: null
        }, clientX, clientY, targetElement)
        // Nettoyer l'élément temporaire et la cible
        if (tempElement.parentNode) {
          tempElement.parentNode.removeChild(tempElement)
        }
        inspectTargets.delete(key)
      }
    } else {
      console.error("No LiveView element found")
      // Afficher un menu de base même sans LiveView
      showComponentMenu({
        nom: "Composant non identifié",
        type: null,
        sous_categorie: null,
        code_source: null
      }, clientX, clientY, targetElement)
    }
  }
  
  // Attacher le listener avec capture: true pour intercepter avant le navigateur
  document.addEventListener("contextmenu", contextMenuHandler, { capture: true, passive: false })
  window.componentInspectorListenerAdded = true
  window.componentInspectorHandler = contextMenuHandler // Garder une référence
  
  console.log("Component inspector initialized and listener attached with capture: true")
}

// Initialiser immédiatement si le DOM est déjà chargé, sinon attendre DOMContentLoaded
if (document.readyState === "loading") {
  document.addEventListener("DOMContentLoaded", initComponentInspector)
} else {
  initComponentInspector()
}

// Handler pour les événements component_inspected envoyés par le serveur
// Utiliser la délégation d'événement sur document pour capturer tous les événements
function handleComponentInspected(event) {
  console.log("🎉 component_inspected event received:", event.detail)
  const detail = event.detail
  if (detail) {
    // Récupérer la cible stockée avec les coordonnées comme clé
    const key = `${detail.x}_${detail.y}`
    const targetElement = inspectTargets.get(key)
    
    console.log("📦 Target element:", targetElement)
    console.log("📦 Component data:", detail.component)
    
    // Fermer le menu "Chargement..." s'il existe
    closeComponentMenu()
    
    if (detail.component && detail.component.nom) {
      console.log("✅ Affichage du menu pour:", detail.component.nom)
      showComponentMenu(detail.component, detail.x, detail.y, targetElement)
    } else {
      console.log("⚠️  Aucun composant trouvé, affichage du menu par défaut")
      // Afficher un menu même si aucun composant n'est trouvé
      showComponentMenu({
        nom: "Composant non identifié",
        type: null,
        sous_categorie: null,
        code_source: null
      }, detail.x, detail.y, targetElement)
    }
    
    // Nettoyer après utilisation
    inspectTargets.delete(key)
  } else {
    console.error("❌ Event detail is empty or undefined")
  }
}

// Attacher le listener sur document avec délégation d'événement
// Cela capture tous les événements phx:component_inspected dispatchés sur n'importe quel élément
document.addEventListener("phx:component_inspected", handleComponentInspected, true)

// Également écouter sur window pour être sûr de capturer l'événement
window.addEventListener("phx:component_inspected", handleComponentInspected, true)

// Utiliser phx:mount pour s'assurer que le listener est prêt après le montage du LiveView
document.addEventListener("phx:mount", () => {
  console.log("✅ LiveView mounted, component_inspected listener is ready")
}, true)

console.log("✅ Component inspected listener attached on document and window")

const csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
const liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: {_csrf_token: csrfToken},
  hooks: {MapHook, ...colocatedHooks},
})

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

// The lines below enable quality of life phoenix_live_reload
// development features:
//
//     1. stream server logs to the browser console
//     2. click on elements to jump to their definitions in your code editor
//
if (process.env.NODE_ENV === "development") {
  window.addEventListener("phx:live_reload:attached", ({detail: reloader}) => {
    // Enable server log streaming to client.
    // Disable with reloader.disableServerLogs()
    reloader.enableServerLogs()

    // Open configured PLUG_EDITOR at file:line of the clicked element's HEEx component
    //
    //   * click with "c" key pressed to open at caller location
    //   * click with "d" key pressed to open at function component definition location
    let keyDown
    window.addEventListener("keydown", e => keyDown = e.key)
    window.addEventListener("keyup", e => keyDown = null)
    window.addEventListener("click", e => {
      if(keyDown === "c"){
        e.preventDefault()
        e.stopImmediatePropagation()
        reloader.openEditorAtCaller(e.target)
      } else if(keyDown === "d"){
        e.preventDefault()
        e.stopImmediatePropagation()
        reloader.openEditorAtDef(e.target)
      }
    }, true)

    window.liveReloader = reloader
  })
}

