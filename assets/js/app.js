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

// Component Inspector Hook - détecte le clic droit et identifie les composants

// Fonction pour afficher un flash (style Waw)
function showFlash(type, message) {
  // Supprimer les flashes existants
  const existingFlash = document.getElementById("component-copy-flash")
  if (existingFlash) {
    existingFlash.remove()
  }

  // Définir les couleurs selon le type
  const colors = {
    success: {
      ring: "ring-green-500",
      bg: "bg-green-50",
      text: "text-green-800",
      textSecondary: "text-green-700",
      icon: "checkmark-icloud-fill"
    },
    danger: {
      ring: "ring-red-500",
      bg: "bg-red-50",
      text: "text-red-800",
      textSecondary: "text-red-700",
      icon: "exclamationmark-circle-fill"
    }
  }

  const color = colors[type] || colors.danger

  // Créer l'élément flash
  const flash = document.createElement("div")
  flash.id = "component-copy-flash"
  flash.className = `fixed top-2 right-2 w-80 sm:w-96 z-50 rounded-lg p-3 ring-1 ${color.ring} ${color.bg} transition-all ease-out duration-300 opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95`
  flash.style.position = "fixed"
  flash.style.top = "0.5rem"
  flash.style.right = "0.5rem"
  flash.setAttribute("role", "alert")

  // Contenu du flash
  flash.innerHTML = `
    <p class="flex items-center gap-1.5 text-sm font-semibold leading-6 pr-4 ${color.text}">
      <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg">
        ${type === "success" 
          ? '<path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"></path>'
          : '<path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd"></path>'
        }
      </svg>
      ${type === "success" ? "Copie réussie" : "Erreur"}
    </p>
    <p class="text-sm leading-5 pr-4 mt-2 ${color.textSecondary}">
      ${message}
    </p>
    <button type="button" class="group absolute top-1 right-1 p-2" aria-label="close">
      <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg">
        <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd"></path>
      </svg>
    </button>
  `

  // Ajouter au body
  document.body.appendChild(flash)

  // Animation d'entrée
  requestAnimationFrame(() => {
    flash.classList.remove("opacity-0", "translate-y-4", "sm:scale-95")
    flash.classList.add("opacity-100", "translate-y-0", "sm:scale-100")
  })

  // Gestion du clic pour fermer
  const closeButton = flash.querySelector("button")
  const closeFlash = () => {
    flash.classList.remove("opacity-100", "translate-y-0", "sm:scale-100")
    flash.classList.add("opacity-0", "translate-y-4", "sm:scale-95")
    setTimeout(() => {
      if (flash.parentNode) {
        flash.remove()
      }
    }, 200)
  }

  closeButton.addEventListener("click", closeFlash)
  flash.addEventListener("click", (e) => {
    if (e.target === flash || e.target.closest("button")) {
      closeFlash()
    }
  })

  // Fermer automatiquement après 5 secondes
  setTimeout(() => {
    if (flash.parentNode) {
      closeFlash()
    }
  }, 5000)
}

// Fonction pour afficher le menu flottant
function showComponentMenu(component, x, y, targetElement) {
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
  
  // Titre (nom du module)
  const title = document.createElement("div")
  title.className = "component-inspector-title"
  title.textContent = component.module || component.nom || "Composant inconnu"
  menu.appendChild(title)
  
  // Sous-titre avec la description (première ligne du @doc)
  if (component.nom && component.nom !== "Composant inconnu" && component.module) {
    const subtitle = document.createElement("div")
    subtitle.className = "component-inspector-subtitle"
    subtitle.textContent = component.nom
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
        showFlash("success", "Code source copié avec succès")
      }).catch(() => {
        closeComponentMenu()
        showFlash("danger", "Erreur lors de la copie")
      })
    } else {
      closeComponentMenu()
      showFlash("danger", "Rien n'est copié car le code source n'est pas disponible")
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
          // ignore inspect() errors silently
        }
      }
      
      // Pour Firefox: utiliser $0 dans la console (nécessite DevTools ouverts)
      if (window.console && console.log) {
        // Intentionally left blank to avoid noisy console logs
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
  
  // Ajuster la position si le menu dépasse de l'écran
  const rect = menu.getBoundingClientRect()
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

const ThemeManagerHook = {
  mounted() {
    this.storageKey = "phx:theme"

    this.setTheme = (theme) => {
      if (theme === "system") {
        localStorage.removeItem(this.storageKey)
        document.documentElement.removeAttribute("data-theme")
      } else {
        localStorage.setItem(this.storageKey, theme)
        document.documentElement.setAttribute("data-theme", theme)
      }
    }

    if (!document.documentElement.hasAttribute("data-theme")) {
      this.setTheme(localStorage.getItem(this.storageKey) || "system")
    }

    this.storageHandler = (event) => {
      if (event.key === this.storageKey) {
        this.setTheme(event.newValue || "system")
      }
    }

    this.themeEventHandler = (event) => {
      const theme = event.target?.dataset?.phxTheme || "system"
      this.setTheme(theme)
    }

    window.addEventListener("storage", this.storageHandler)
    window.addEventListener("phx:set-theme", this.themeEventHandler)
  },

  destroyed() {
    window.removeEventListener("storage", this.storageHandler)
    window.removeEventListener("phx:set-theme", this.themeEventHandler)
  }
}

const ContextMenuNotificationHook = {
  mounted() {
    this.storageKey = "waw_showcase_context_menu_notification_shown"
    this.delay = Number(this.el.dataset.popupDelay || "500")

    this.dismissHandler = (event) => {
      const button = event.target?.closest("[data-context-menu-popup-button]")
      if (button && this.el.contains(button)) {
        this.hide()
      }
    }

    document.addEventListener("click", this.dismissHandler)

    if (!sessionStorage.getItem(this.storageKey)) {
      this.showTimer = window.setTimeout(() => this.show(), this.delay)
    } else {
      this.hide(true)
    }
  },

  destroyed() {
    document.removeEventListener("click", this.dismissHandler)
    if (this.showTimer) {
      window.clearTimeout(this.showTimer)
    }
  },

  show() {
    sessionStorage.setItem(this.storageKey, "true")
    this.el.classList.remove("hidden")

    requestAnimationFrame(() => {
      this.el.classList.remove("opacity-0", "pointer-events-none")
      this.el.classList.add("opacity-100")
    })
  },

  hide(force = false) {
    if (force) {
      this.el.classList.add("hidden", "opacity-0", "pointer-events-none")
      return
    }

    this.el.classList.add("opacity-0", "pointer-events-none")
    window.setTimeout(() => this.el.classList.add("hidden"), 200)
  }
}

// Initialiser l'inspecteur de composants directement sur document
// Utiliser capture: true pour intercepter l'événement avant qu'il ne soit traité par le navigateur
function initComponentInspector() {
  // Éviter d'ajouter plusieurs listeners
  if (window.componentInspectorListenerAdded) {
    return
  }
    
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
    
    // Si elementFromPoint est différent de event.target, on privilégie elementFromPoint
    // (cas d'overlays, de wrappers ou de captures d'événements).
    let targetElement = event.target
    if (
      elementFromPoint &&
      elementFromPoint !== event.target &&
      elementFromPoint.tagName &&
      !["html", "body"].includes(elementFromPoint.tagName.toLowerCase())
    ) {
      targetElement = elementFromPoint
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
    
    // componentName est utilisée côté serveur via data-component
    // Trouver le LiveView actif et envoyer l'événement avec les coordonnées
    const liveViewEl = document.querySelector('[data-phx-main]')
    if (liveViewEl) {
      // Pour les inputs, extraire le type depuis l'élément ou ses parents
      let inputType = null
      if (componentName === "input") {
        // Chercher l'attribut type sur l'élément ou ses parents
        let element = targetElement
        while (element && !inputType) {
          inputType = element.getAttribute("type") || element.getAttribute("data-type")
          element = element.parentElement
        }
      }
      
      // Préparer les données de l'événement (seulement ce qui est réellement utilisé côté serveur)
      const eventData = {
        tag: targetElement.tagName.toLowerCase(),
        x: clientX,
        y: clientY,
        component: componentName,
        input_type: inputType
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
      if (eventData.component) {
        tempElement.setAttribute("phx-value-component", eventData.component)
      }
      if (eventData.input_type) {
        tempElement.setAttribute("phx-value-input-type", eventData.input_type)
      }
      // eventData est envoyé via phx-value-* attributes
      liveViewEl.appendChild(tempElement)
      
      // Déclencher le clic programmatiquement
      try {
        tempElement.click()
        // Afficher un menu temporaire en attendant la réponse
        showComponentMenu({
          nom: "Chargement...",
          code_source: null
        }, clientX, clientY, targetElement)
        
        // Nettoyer l'élément temporaire après un court délai
        setTimeout(() => {
          if (tempElement.parentNode) {
            tempElement.parentNode.removeChild(tempElement)
          }
        }, 1000)
      } catch (error) {
        // Afficher un menu de base en cas d'erreur
        showComponentMenu({
          nom: "Composant non identifié",
          code_source: null
        }, clientX, clientY, targetElement)
        // Nettoyer l'élément temporaire et la cible
        if (tempElement.parentNode) {
          tempElement.parentNode.removeChild(tempElement)
        }
        inspectTargets.delete(key)
      }
    } else {
      // Afficher un menu de base même sans LiveView
      showComponentMenu({
        nom: "Composant non identifié",
        code_source: null
      }, clientX, clientY, targetElement)
    }
  }
  
  // Attacher le listener avec capture: true pour intercepter avant le navigateur
  document.addEventListener("contextmenu", contextMenuHandler, { capture: true, passive: false })
  window.componentInspectorListenerAdded = true
  window.componentInspectorHandler = contextMenuHandler // Garder une référence
  
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
  const detail = event.detail
  if (detail) {
    // Récupérer la cible stockée avec les coordonnées comme clé
    const key = `${detail.x}_${detail.y}`
    const targetElement = inspectTargets.get(key)
    
    // Fermer le menu "Chargement..." s'il existe
    closeComponentMenu()
    
    if (detail.component && detail.component.nom) {
      // Debug: vérifier que le code_source est présent
      if (!detail.component.code_source) {
        console.warn("Component code_source is missing:", detail.component)
      }
      showComponentMenu(detail.component, detail.x, detail.y, targetElement)
    } else {
      // Afficher un menu même si aucun composant n'est trouvé
      showComponentMenu({
        nom: "Composant non identifié",
        code_source: null,
        module: null
      }, detail.x, detail.y, targetElement)
    }
    
    // Nettoyer après utilisation
    inspectTargets.delete(key)
  } else {
    // No detail – nothing to display
  }
}

// Attacher le listener sur document avec délégation d'événement
// Cela capture tous les événements phx:component_inspected dispatchés sur n'importe quel élément
document.addEventListener("phx:component_inspected", handleComponentInspected, true)

// Également écouter sur window pour être sûr de capturer l'événement
window.addEventListener("phx:component_inspected", handleComponentInspected, true)

// Utiliser phx:mount pour s'assurer que le listener est prêt après le montage du LiveView
document.addEventListener("phx:mount", () => {
}, true)

// ---
// Sécurisation de l'affichage des éléments de navigation "persistants"
// (header/footer fixes, barre d'onglets) même après changements d'onglets
// ou interactions complexes (modals, écrans internes).
// ---

function ensurePersistentShellVisibility() {
  // Header + footer fixes
  const shellContainers = document.querySelectorAll(
    '[data-component="Header et Footer fixes"]'
  )

  shellContainers.forEach((el) => {
    el.classList.remove("hidden", "invisible")
    el.style.display = ""
    el.style.visibility = ""
    el.style.opacity = ""
  })

  // Onglets (Rapports) – s'assurer que le conteneur et ses boutons restent visibles
  const tabsContainers = document.querySelectorAll(
    '[data-component="Onglets - taille moyenne"]'
  )

  tabsContainers.forEach((container) => {
    container.classList.remove("hidden", "invisible")
    container.style.display = ""
    container.style.visibility = ""
    container.style.opacity = ""

    const buttons = container.querySelectorAll("button")
    buttons.forEach((btn) => {
      btn.classList.remove("hidden", "invisible")
      btn.style.display = ""
      btn.style.visibility = ""
      btn.style.opacity = ""
    })
  })
}

// Observer générique sur le body pour ré-appliquer les règles ci-dessus
// après chaque patch LiveView (changement d'onglet, ouverture/fermeture de modal, etc.).
const shellObserver = new MutationObserver(() => {
  // On debounce légèrement pour ne pas exécuter trop souvent pendant un gros patch
  if (shellObserver._pending) return
  shellObserver._pending = true
  setTimeout(() => {
    shellObserver._pending = false
    ensurePersistentShellVisibility()
  }, 30)
})

if (document.body) {
  shellObserver.observe(document.body, {
    childList: true,
    subtree: true
  })
  // Appliquer une première fois au chargement
  ensurePersistentShellVisibility()
}


const hooks = {
  ...colocatedHooks,
  ThemeManager: ThemeManagerHook,
  ContextMenuNotification: ContextMenuNotificationHook
}

const csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
const liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: {_csrf_token: csrfToken},
  hooks,
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
    // NOTE: server log streaming to the browser console is disabled to avoid noise
    // If you need it for debugging, call reloader.enableServerLogs() manually from the console.

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

