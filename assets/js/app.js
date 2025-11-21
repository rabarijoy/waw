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
const ComponentInspectorHook = {
  mounted() {
    // Écouter l'événement contextmenu (clic droit) sur tout le document
    this.handleContextMenu = (event) => {
      event.preventDefault()
      
      const target = event.target
      const domPath = []
      let current = target
      
      // Construire le chemin DOM en remontant jusqu'à l'élément avec le hook
      while (current && current !== this.el && current !== document.documentElement) {
        const tag = current.tagName.toLowerCase()
        const attributes = extractAttributes(current)
        
        domPath.push({
          tag: tag,
          attributes: attributes
        })
        
        current = current.parentElement
      }
      
      // Trouver le LiveView actif et envoyer l'événement
      const liveViewEl = document.querySelector('[data-phx-main]')
      if (liveViewEl && liveViewEl.__view) {
        const view = liveViewEl.__view
        if (view.pushEvent) {
          view.pushEvent("inspect_component", {
            tag: target.tagName.toLowerCase(),
            attributes: extractAttributes(target),
            dom_path: domPath
          })
        }
      }
    }
    
    this.el.addEventListener("contextmenu", this.handleContextMenu)
  },
  
  destroyed() {
    if (this.handleContextMenu) {
      this.el.removeEventListener("contextmenu", this.handleContextMenu)
    }
  }
}

// Fonction helper pour extraire les attributs d'un élément DOM
function extractAttributes(element) {
  const attributes = {}
  
  if (element.attributes) {
    for (let i = 0; i < element.attributes.length; i++) {
      const attr = element.attributes[i]
      // Ignorer les attributs spéciaux de Phoenix LiveView et les attributs génériques
      if (!attr.name.startsWith("phx-") && 
          !attr.name.startsWith("data-phx-") &&
          attr.name !== "id" && 
          attr.name !== "class" &&
          attr.name !== "style") {
        attributes[attr.name] = attr.value
      }
    }
  }
  
  return attributes
}

const csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
const liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: {_csrf_token: csrfToken},
  hooks: {MapHook, ComponentInspectorHook, ...colocatedHooks},
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

