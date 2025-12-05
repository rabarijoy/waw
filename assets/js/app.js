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
  // Afficher le nom du composant comme titre, le module comme sous-titre
  title.textContent = component.nom || component.module || "Composant inconnu"
  menu.appendChild(title)
  
  // Sous-titre avec le module (si différent du nom)
  if (component.module && component.module !== component.nom) {
    const subtitle = document.createElement("div")
    subtitle.className = "component-inspector-subtitle"
    subtitle.textContent = component.module
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
    // Vérifier si on est dans la page UI - désactiver le menu contextuel
    const uiPanel = document.getElementById("ui-library-panel")
    if (uiPanel && !uiPanel.classList.contains("hidden")) {
      // On est dans la page UI, ne pas afficher le menu contextuel
      return
    }
    
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
        // Phoenix convertit les tirets en underscores dans phx-value-*
        // Utiliser input-type pour que ça devienne input_type dans les params
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

// --- Mode Demo / UI (switch global) ---

// Persistance du mode Demo/UI entre les pages
let currentMode = (function () {
  try {
    const stored = window.localStorage.getItem("waw-showcase-mode")
    return stored === "ui" ? "ui" : "demo"
  } catch (_e) {
    return "demo"
  }
})()

function applyMode(mode) {
  currentMode = mode

  // Mémoriser le mode pour les prochains rechargements
  try {
    window.localStorage.setItem("waw-showcase-mode", mode)
  } catch (_e) {
    // Ignorer les erreurs de stockage (mode privé, etc.)
  }

  const body = document.getElementById("app-body") || document.body
  if (body) {
    body.dataset.appMode = mode
  }

  const navWrapper = document.querySelector(".app-main-nav") || document.querySelector("[id^='app-main-nav-']")
  const mainContent = document.getElementById("app-main-content")
  const uiPanel = document.getElementById("ui-library-panel")
  
  // Debug: vérifier que les éléments sont trouvés
  if (!mainContent) {
    console.warn("app-main-content not found")
  }
  if (!uiPanel) {
    console.warn("ui-library-panel not found")
  }

  // Mettre à jour les boutons desktop
  const desktopButtons = document.querySelectorAll("[data-mode-toggle=\"desktop\"]")
  desktopButtons.forEach((btn) => {
    const value = btn.getAttribute("data-mode-value")
    const isActive = value === mode
    btn.classList.toggle("bg-gray-900", isActive)
    btn.classList.toggle("text-white", isActive)
    btn.classList.toggle("hover:bg-gray-800", isActive)
    btn.classList.toggle("text-gray-500", !isActive)
    btn.classList.toggle("hover:text-gray-900", !isActive)
    btn.classList.toggle("hover:bg-gray-50", !isActive)
  })

  // Mettre à jour la pillule mobile
  const mobileButton = document.querySelector("[data-mode-toggle=\"mobile\"]")
  if (mobileButton) {
    const activeLabel = mobileButton.querySelector("[data-mode-active-label]")
    const altLabel = mobileButton.querySelector("[data-mode-alt-label]")

    if (activeLabel && altLabel) {
      if (mode === "demo") {
        activeLabel.textContent = "Demo"
        altLabel.textContent = "Voir l’UI"
      } else {
        activeLabel.textContent = "UI"
        altLabel.textContent = "Voir la démo"
      }
    }
  }

  // Afficher / masquer la navbar principale
  if (navWrapper) {
    if (mode === "ui") {
      navWrapper.classList.add("opacity-0", "pointer-events-none", "scale-95")
    } else {
      navWrapper.classList.remove("opacity-0", "pointer-events-none", "scale-95")
    }
  }

  // Afficher / masquer le contenu principal vs bibliothèque UI
  if (mainContent && uiPanel) {
    if (mode === "ui") {
      mainContent.classList.add("hidden")
      uiPanel.classList.remove("hidden")
      // Forcer l'affichage immédiatement
      uiPanel.style.display = ""
      uiPanel.style.opacity = "1"
      uiPanel.classList.remove("opacity-0")
    } else {
      uiPanel.classList.add("opacity-0")
      setTimeout(() => {
        uiPanel.classList.add("hidden")
      }, 200)
      mainContent.classList.remove("hidden")
      mainContent.style.display = ""
    }
  }
}

function initModeSwitch() {
  // Appliquer le mode courant sur le DOM actuel
  applyMode(currentMode)

  // Délégation globale pour tous les boutons Demo/UI (desktop + mobile)
  if (!window.wawModeSwitchInitialized) {
    // Utiliser la capture pour intercepter les clics avant qu'ils ne soient gérés par LiveView
    document.addEventListener(
      "click",
      (event) => {
        // Vérifier si le clic vient d'un bouton mode-toggle ou d'un élément à l'intérieur
        let btn = event.target.closest("[data-mode-toggle]")
        
        // Si pas trouvé avec closest, essayer directement sur l'élément
        if (!btn && event.target.hasAttribute && event.target.hasAttribute("data-mode-toggle")) {
          btn = event.target
        }
        
        // Vérifier aussi si le parent est un bouton
        if (!btn && event.target.parentElement && event.target.parentElement.hasAttribute("data-mode-toggle")) {
          btn = event.target.parentElement
        }
        
        if (!btn) return
        
        // Si le clic est déclenché depuis un élément à l'intérieur de la popup UI, l'ignorer
        if (event.target.closest("#ui-preview-modal")) return
        
        // Empêcher le comportement par défaut et la propagation
        event.preventDefault()
        event.stopPropagation()
        event.stopImmediatePropagation()

        const explicitValue = btn.getAttribute("data-mode-value")
        let nextMode = explicitValue

        // Si aucun value explicite, on toggle simplement
        if (!nextMode) {
          nextMode = currentMode === "demo" ? "ui" : "demo"
        }

        if (nextMode && nextMode !== currentMode) {
          applyMode(nextMode)
        }
        
        return false
      },
      true // Utiliser la phase de capture pour intercepter avant LiveView
    )

    // À chaque fin de mise à jour LiveView (événements, formulaires, navigation),
    // on réapplique le mode courant pour garder l'UI ou la Demo visible correctement.
    window.addEventListener("phx:page-loading-stop", () => {
      applyMode(currentMode)
    })

    // Marquer l'initialisation globale pour éviter les doublons
    window.wawModeSwitchInitialized = true
  }
}

// --- Désactiver les liens dans la page UI ---

function initUiLinkDisabler() {
  const uiPanel = document.getElementById("ui-library-panel")
  const uiModal = document.getElementById("ui-preview-modal")
  
  // Fonction pour bloquer la navigation
  const blockNavigation = (event) => {
    // Ne pas bloquer les clics sur les éléments de contrôle de la modal elle-même
    if (event.target.closest("#ui-preview-modal-header, #ui-preview-modal-close, .variant-nav, .copy-code-btn")) {
      return
    }
    
    // Trouver le lien le plus proche (a, ou élément avec href/navigate/phx-click)
    const link = event.target.closest("a, [href], [navigate], [data-navigate], [phx-click], [data-phx-link], button")
    if (!link) return

    // Vérifier si c'est un élément avec navigation
    const href = link.getAttribute("href")
    const navigate = link.getAttribute("navigate")
    const dataNavigate = link.getAttribute("data-navigate")
    const phxClick = link.getAttribute("phx-click")
    const phxLink = link.getAttribute("data-phx-link")
    
    // Vérifier si le phx-click contient "navigate" ou "patch"
    const hasNavigation = phxClick && (phxClick.includes("navigate") || phxClick.includes("patch"))
    
    // Si c'est un lien vers #, une route, ou un navigate, bloquer
    if (href || navigate || dataNavigate || hasNavigation || phxLink) {
      // Ignorer les liens vers # ou vides
      if (href && href !== "#" && href !== "") {
        event.preventDefault()
        event.stopPropagation()
        event.stopImmediatePropagation()
        return false
      }
      // Bloquer tous les navigate et phx-click de navigation
      if (navigate || dataNavigate || hasNavigation || phxLink) {
        event.preventDefault()
        event.stopPropagation()
        event.stopImmediatePropagation()
        return false
      }
    }
  }

  // Intercepter tous les clics dans la zone UI
  if (uiPanel) {
    uiPanel.addEventListener("click", blockNavigation, true)
  }
  
  // Intercepter aussi dans la modal de preview
  if (uiModal) {
    uiModal.addEventListener("click", blockNavigation, true)
  }
  
  // Intercepter aussi les événements phx:click avant qu'ils ne soient traités par LiveView
  const blockPhxEvents = (event) => {
    // Ne pas bloquer les événements sur les éléments de contrôle
    if (event.target.closest("#ui-preview-modal-header, #ui-preview-modal-close, .variant-nav, .copy-code-btn")) {
      return
    }
    
    // Vérifier si l'événement vient d'un élément avec navigation
    const target = event.target.closest("[navigate], [data-phx-link], [phx-click]")
    if (target) {
      const navigate = target.getAttribute("navigate")
      const phxLink = target.getAttribute("data-phx-link")
      const phxClick = target.getAttribute("phx-click")
      const hasNavigation = phxClick && (phxClick.includes("navigate") || phxClick.includes("patch"))
      
      if (navigate || phxLink || hasNavigation) {
        event.preventDefault()
        event.stopPropagation()
        event.stopImmediatePropagation()
        return false
      }
    }
  }
  
  // Intercepter les événements phx:click dans la phase de capture
  if (uiPanel) {
    uiPanel.addEventListener("phx:click", blockPhxEvents, true)
  }
  
  if (uiModal) {
    uiModal.addEventListener("phx:click", blockPhxEvents, true)
  }
}

// Initialiser le désactivateur de liens UI
if (document.readyState === "loading") {
  document.addEventListener("DOMContentLoaded", initUiLinkDisabler)
} else {
  initUiLinkDisabler()
}

// Réinitialiser après chaque mise à jour LiveView de la zone UI
window.addEventListener("phx:page-loading-stop", () => {
  initUiLinkDisabler()
})

// --- Popup UI pour la bibliothèque de composants ---

function initUiPreviewModal() {
  const modal = document.getElementById("ui-preview-modal")
  if (!modal) return

  const backdrop = modal
  const titleEl = modal.querySelector("#ui-preview-title")
  const moduleEl = modal.querySelector("#ui-preview-module")
  const componentEl = modal.querySelector("#ui-preview-component")
  const codeEl = modal.querySelector("#ui-preview-code")
  const closeBtn = modal.querySelector("[data-ui-preview-close]")
  const copyBtn = modal.querySelector("[data-ui-preview-copy]")
  const variantsContainer = modal.querySelector("#ui-preview-variants-nav")

  let currentVariants = []
  let currentVariantIndex = 0
  let currentGroupIndex = 0 // Index du groupe principal sélectionné (pour navigation hiérarchique)

  function closeModal() {
    modal.classList.add("hidden")
    currentVariants = []
    currentVariantIndex = 0
  }

  function renderVariantsNav(variants, container, principalNom, hidePrincipal = false) {
    if (!container) return
    
    // Vérifier si les variantes ont des sous-variantes (structure hiérarchique)
    const hasSubVariants = variants.some(v => v.sous_variantes && Array.isArray(v.sous_variantes))
    
    if (hasSubVariants) {
      // Structure hiérarchique : groupes avec sous-variantes
      renderHierarchicalNav(variants, container, principalNom, hidePrincipal)
    } else {
      // Structure plate : variantes simples
      renderFlatNav(variants, container, principalNom, hidePrincipal)
    }
  }

  function renderHierarchicalNav(variants, container, principalNom, hidePrincipal) {
    container.innerHTML = ""
    
    // Construire la liste plate pour le rendu
    const allVariants = hidePrincipal
      ? []
      : [{ nom: principalNom || "Principal", code_source: null, isPrincipal: true }]
    
    // Aplatir les variantes avec sous-variantes
    let flatIndex = allVariants.length
    const groupsWithSubVariants = []
    
    variants.forEach((variant) => {
      if (variant.sous_variantes && Array.isArray(variant.sous_variantes)) {
        const groupSubVariants = []
        variant.sous_variantes.forEach((subVariant) => {
          const flatVariant = {
            nom: `${variant.nom} - ${subVariant.nom}`,
            code_source: subVariant.code_source,
            isPrincipal: false,
            groupNom: variant.nom,
            subNom: subVariant.nom,
            _index: flatIndex++
          }
          allVariants.push(flatVariant)
          groupSubVariants.push(flatVariant)
        })
        groupsWithSubVariants.push({
          nom: variant.nom,
          subVariants: groupSubVariants
        })
      } else {
        // Variante simple sans sous-variantes
        const flatVariant = {
          nom: variant.nom,
          code_source: variant.code_source,
          isPrincipal: false,
          groupNom: null,
          _index: flatIndex++
        }
        allVariants.push(flatVariant)
      }
    })
    
    if (allVariants.length <= 1) {
      container.style.display = "none"
      return
    }

    container.style.display = "flex"
    const navWrapper = document.createElement("div")
    navWrapper.className = "flex flex-col gap-3 w-full"
    
    // Stocker les données pour les fonctions de callback
    navWrapper.setAttribute("data-all-variants", JSON.stringify(allVariants))
    navWrapper.setAttribute("data-groups", JSON.stringify(groupsWithSubVariants))
    
    // Première ligne : Navigation des grandes variantes (groupes)
    const groupsNavWrapper = document.createElement("div")
    groupsNavWrapper.className = "flex flex-wrap justify-center gap-1 rounded-full bg-gray-100 p-1 text-xs font-medium text-gray-600"
    groupsNavWrapper.id = "groups-nav"
    
    groupsWithSubVariants.forEach((group, groupIdx) => {
      const btn = document.createElement("button")
      btn.type = "button"
      btn.className = groupIdx === currentGroupIndex
        ? "px-3 py-1.5 rounded-full bg-white text-gray-900 shadow-sm transition-colors duration-150 max-w-[200px] truncate"
        : "px-3 py-1.5 rounded-full text-gray-500 hover:text-gray-900 hover:bg-gray-50 transition-colors duration-150 max-w-[200px] truncate"
      
      btn.textContent = group.nom
      btn.title = group.nom
      btn.style.textOverflow = "ellipsis"
      btn.style.overflow = "hidden"
      btn.style.whiteSpace = "nowrap"
      
      btn.addEventListener("click", () => {
        currentGroupIndex = groupIdx
        // Mettre à jour l'affichage des boutons de groupes
        updateGroupsNavButtons(groupsNavWrapper, groupsWithSubVariants)
        // Mettre à jour la navigation des sous-variantes
        updateSubVariantsNav(group.subVariants, navWrapper, allVariants)
        // Sélectionner automatiquement la première sous-variante du groupe
        if (group.subVariants.length > 0) {
          currentVariantIndex = group.subVariants[0]._index
          updateVariantDisplay(group.subVariants[0], allVariants)
        }
      })
      
      groupsNavWrapper.appendChild(btn)
    })
    
    navWrapper.appendChild(groupsNavWrapper)
    
    // Deuxième ligne : Navigation des sous-variantes (dynamique selon le groupe sélectionné)
    const subVariantsNavWrapper = document.createElement("div")
    subVariantsNavWrapper.className = "flex flex-wrap justify-center gap-1 rounded-full bg-gray-100 p-1 text-xs font-medium text-gray-600"
    subVariantsNavWrapper.id = "sub-variants-nav"
    
    // Ajouter d'abord le conteneur au DOM avant de le remplir
    navWrapper.appendChild(subVariantsNavWrapper)
    
    // Afficher les sous-variantes du premier groupe par défaut
    if (groupsWithSubVariants.length > 0 && currentGroupIndex < groupsWithSubVariants.length) {
      const selectedGroup = groupsWithSubVariants[currentGroupIndex]
      updateSubVariantsNav(selectedGroup.subVariants, navWrapper, allVariants)
      // Sélectionner la première sous-variante par défaut
      if (selectedGroup.subVariants.length > 0) {
        currentVariantIndex = selectedGroup.subVariants[0]._index
        updateVariantDisplay(selectedGroup.subVariants[0], allVariants)
      }
    }
    
    container.appendChild(navWrapper)
  }
  
  function updateGroupsNavButtons(container, groups) {
    const buttons = container.querySelectorAll("button")
    buttons.forEach((btn, idx) => {
      btn.className = idx === currentGroupIndex
        ? "px-3 py-1.5 rounded-full bg-white text-gray-900 shadow-sm transition-colors duration-150 max-w-[200px] truncate"
        : "px-3 py-1.5 rounded-full text-gray-500 hover:text-gray-900 hover:bg-gray-50 transition-colors duration-150 max-w-[200px] truncate"
    })
  }
  
  function updateSubVariantsNav(subVariants, navWrapper, allVariants) {
    const subVariantsNavWrapper = navWrapper.querySelector("#sub-variants-nav")
    if (!subVariantsNavWrapper) return
    
    subVariantsNavWrapper.innerHTML = ""
    
    if (subVariants.length === 0) {
      subVariantsNavWrapper.style.display = "none"
      return
    }
    
    subVariantsNavWrapper.style.display = "flex"
    
    subVariants.forEach((variant) => {
      const btn = document.createElement("button")
      btn.type = "button"
      const isActive = variant._index === currentVariantIndex
      btn.className = isActive
        ? "px-3 py-1.5 rounded-full bg-white text-gray-900 shadow-sm transition-colors duration-150 max-w-[200px] truncate"
        : "px-3 py-1.5 rounded-full text-gray-500 hover:text-gray-900 hover:bg-gray-50 transition-colors duration-150 max-w-[200px] truncate"
      
      // Afficher seulement le nom de la sous-variante (sans le nom du groupe)
      const displayText = variant.subNom || variant.nom.replace(`${variant.groupNom} - `, "")
      btn.textContent = displayText
      btn.title = variant.nom
      
      btn.style.textOverflow = "ellipsis"
      btn.style.overflow = "hidden"
      btn.style.whiteSpace = "nowrap"
      
      btn.addEventListener("click", () => {
        currentVariantIndex = variant._index
        updateVariantDisplay(variant, allVariants)
        // Mettre à jour l'affichage des boutons de sous-variantes
        updateSubVariantsNavButtons(subVariantsNavWrapper, subVariants)
      })
      
      subVariantsNavWrapper.appendChild(btn)
    })
  }
  
  function updateSubVariantsNavButtons(container, subVariants) {
    const buttons = container.querySelectorAll("button")
    buttons.forEach((btn, idx) => {
      const variant = subVariants[idx]
      const isActive = variant && variant._index === currentVariantIndex
      btn.className = isActive
        ? "px-3 py-1.5 rounded-full bg-white text-gray-900 shadow-sm transition-colors duration-150 max-w-[200px] truncate"
        : "px-3 py-1.5 rounded-full text-gray-500 hover:text-gray-900 hover:bg-gray-50 transition-colors duration-150 max-w-[200px] truncate"
    })
  }

  function renderFlatNav(variants, container, principalNom, hidePrincipal) {
    // Construire la liste des variantes pour la nav
    // Assigner un _index à chaque variante pour correspondre aux index dans le template
    let flatIndex = hidePrincipal ? 0 : 1 // Le principal est à l'index 0 si présent
    const allVariants = hidePrincipal
      ? variants.map(v => ({ ...v, isPrincipal: false, _index: flatIndex++ }))
      : [
          { nom: principalNom || "Principal", code_source: null, isPrincipal: true, _index: 0 },
          ...variants.map(v => ({ ...v, isPrincipal: false, _index: flatIndex++ }))
        ]

    container.innerHTML = ""
    
    if (allVariants.length <= 1) {
      container.style.display = "none"
      return
    }

    container.style.display = "flex"
    const navWrapper = document.createElement("div")
    navWrapper.className = "flex flex-wrap justify-center gap-1 rounded-full bg-gray-100 p-1 text-xs font-medium text-gray-600 max-w-full"

    allVariants.forEach((variant, index) => {
      const btn = document.createElement("button")
      btn.type = "button"
      btn.className = index === currentVariantIndex
        ? "px-3 py-1.5 rounded-full bg-white text-gray-900 shadow-sm transition-colors duration-150 max-w-[200px] truncate"
        : "px-3 py-1.5 rounded-full text-gray-500 hover:text-gray-900 hover:bg-gray-50 transition-colors duration-150 max-w-[200px] truncate"
      
      const displayText = variant.nom || principalNom || "Principal"
      btn.textContent = displayText
      btn.title = displayText
      
      btn.style.textOverflow = "ellipsis"
      btn.style.overflow = "hidden"
      btn.style.whiteSpace = "nowrap"
      
      btn.addEventListener("click", () => {
        currentVariantIndex = index
        updateVariantDisplay(allVariants[index], allVariants)
      })
      
      navWrapper.appendChild(btn)
    })

    container.appendChild(navWrapper)
  }

  function updateVariantDisplay(variant, allVariants) {
    const cardId = modal.getAttribute("data-current-card-id")
    if (!cardId) {
      console.error("No card ID found in modal")
      return
    }
    
    let card = document.getElementById(cardId)
    if (!card) {
      console.error(`Card with ID "${cardId}" not found in DOM`)
      // Essayer de trouver la carte par data-component-title depuis la modal
      const sousCategorie = modal.getAttribute("data-current-sous-categorie") || ""
      if (sousCategorie) {
        const cards = document.querySelectorAll(`[data-component-title="${sousCategorie}"]`)
        if (cards.length > 0) {
          console.log(`Found ${cards.length} card(s) with sous_categorie "${sousCategorie}", using first one`)
          card = cards[0]
          // Mettre à jour l'ID de la carte et de la modal
          if (!card.id) {
            card.id = cardId
          }
          modal.setAttribute("data-current-card-id", card.id)
        } else {
          console.error(`No card found with sous_categorie "${sousCategorie}"`)
          return
        }
      } else {
        console.error("No sous_categorie found in modal")
        return
      }
    }

    const principalCode = card.getAttribute("data-component-principal-code") || ""
    const principalNom = card.getAttribute("data-component-principal-nom") || card.getAttribute("data-component-title") || ""
    const code = variant.isPrincipal ? principalCode : (variant.code_source || "")
    const sousCategorie = card.getAttribute("data-component-title") || ""
    const hidePrincipal = sousCategorie === "Distance"

    if (codeEl) {
      codeEl.textContent = code.trim()
    }

    // Pour le composant principal, cloner le HTML rendu depuis la card
    if (variant.isPrincipal && componentEl) {
      const previewDiv = card.querySelector(".component-preview")
      if (previewDiv) {
        componentEl.innerHTML = ""
        const clone = previewDiv.cloneNode(true)
        // Retirer les classes de cursor-pointer et hover pour la popup
        clone.classList.remove("cursor-pointer", "hover:border-gray-300")
        componentEl.appendChild(clone)
      } else {
        componentEl.innerHTML = `<div class="text-xs text-gray-400 p-4">Aperçu non disponible</div>`
      }
    } else if (componentEl) {
      // Pour les variantes, cloner le HTML pré-rendu caché dans la carte
      // Utiliser d'abord le nom de la variante pour trouver le conteneur (plus fiable que l'index)
      let variantContainer = null
      
      // Debug: vérifier que le conteneur .variant-previews existe
      const variantPreviewsContainer = card.querySelector('.variant-previews')
      console.log(`Looking for variant "${variant.nom}" in card:`, {
        cardId: card.id,
        cardTitle: card.getAttribute('data-component-title'),
        variantNom: variant.nom,
        variantPreviewsExists: variantPreviewsContainer !== null,
        variantPreviewsHTML: variantPreviewsContainer ? variantPreviewsContainer.innerHTML.substring(0, 500) : 'NOT FOUND'
      })
      
      if (variant.nom && variantPreviewsContainer) {
        // Méthode 1: Chercher directement par nom de variante (le plus fiable)
        // Échapper les caractères spéciaux dans le nom pour le sélecteur CSS
        const escapedNom = variant.nom.replace(/[!"#$%&'()*+,.\/:;<=>?@[\\\]^`{|}~]/g, '\\$&')
        const selector = `.variant-previews [data-variant-nom="${escapedNom}"] .component-preview-variant`
        console.log(`Trying selector: "${selector}"`)
        variantContainer = card.querySelector(selector)
        
        // Méthode 2: Si pas trouvé, chercher dans tous les conteneurs par nom (comparaison directe)
        if (!variantContainer) {
          const allContainers = variantPreviewsContainer.querySelectorAll('[data-variant-index]')
          console.log(`Searching in ${allContainers.length} containers for variant "${variant.nom}"`)
          for (const container of allContainers) {
            const containerNom = container.getAttribute('data-variant-nom')
            console.log(`  Container nom: "${containerNom}", looking for: "${variant.nom}", match: ${containerNom === variant.nom}`)
            if (containerNom === variant.nom) {
              variantContainer = container.querySelector('.component-preview-variant')
              if (variantContainer) {
                console.log(`Found variant container by name!`)
                break
              }
            }
          }
        } else {
          console.log(`Found variant container by CSS selector!`)
        }
      } else {
        console.warn(`Cannot search for variant: variant.nom=${variant.nom}, variantPreviewsContainer=${!!variantPreviewsContainer}`)
      }
      
      // Méthode 3: Fallback par index si le nom ne fonctionne pas
      if (!variantContainer) {
        let variantIndex
        if (typeof variant._index === "number") {
          variantIndex = variant._index - (hidePrincipal ? 0 : 1)
        } else {
          const variantPos = allVariants.findIndex(v => 
            v.nom === variant.nom && 
            v.code_source === variant.code_source &&
            v.isPrincipal === variant.isPrincipal
          )
          variantIndex = variantPos >= 0 ? variantPos - (hidePrincipal ? 0 : 1) : 0
        }
        if (variantIndex >= 0) {
          variantContainer = card.querySelector(`.variant-previews [data-variant-index="${variantIndex}"] .component-preview-variant`)
        }
      }

      if (variantContainer) {
        // Vérifier que le conteneur contient bien du HTML rendu et non juste du texte
        const containerHTML = variantContainer.innerHTML.trim()
        
        // Debug: afficher le contenu du conteneur pour diagnostiquer
        console.log(`Variant container found for "${variant.nom}":`, {
          containerHTML: containerHTML.substring(0, 200),
          startsWithWaw: containerHTML.startsWith('<.waw_'),
          startsWithInput: containerHTML.startsWith('<.input'),
          startsWithLive: containerHTML.startsWith('<.live_'),
          startsWithDiv: containerHTML.startsWith('<div'),
          startsWithButton: containerHTML.startsWith('<button')
        })
        
        // Si le conteneur contient le code source en texte (commence par <.waw_ ou <.input), c'est qu'il n'a pas été rendu
        if (containerHTML.startsWith('<.waw_') || containerHTML.startsWith('<.input') || containerHTML.startsWith('<.live_')) {
          console.error(`Variant container found but contains UNRENDERED code!`, {
            variant: variant,
            sousCategorie: card.getAttribute('data-component-title'),
            containerHTML: containerHTML.substring(0, 200)
          })
          // Afficher le code source comme fallback
          componentEl.innerHTML = `<pre class="text-xs text-gray-600 whitespace-pre-wrap p-4 bg-gray-50 rounded-lg">${code.trim() || "Code source non disponible"}</pre>`
        } else {
          // Le conteneur contient du HTML rendu, on peut le cloner
          componentEl.innerHTML = ""
          const clone = variantContainer.cloneNode(true)
          componentEl.appendChild(clone)
        }
      } else {
        // Debug: vérifier tous les conteneurs disponibles pour diagnostiquer
        const variantPreviewsContainer = card.querySelector('.variant-previews')
        const allVariantContainers = variantPreviewsContainer 
          ? variantPreviewsContainer.querySelectorAll('[data-variant-index]')
          : []
        
        console.error(`Variant preview not found!`, {
          variant: variant,
          variantNom: variant.nom,
          sousCategorie: card.getAttribute('data-component-title'),
          hidePrincipal: hidePrincipal,
          variantIndexInAllVariants: variant._index,
          variantPreviewsExists: variantPreviewsContainer !== null,
          totalContainers: allVariantContainers.length,
          availableVariants: Array.from(allVariantContainers).map(c => ({
            index: c.getAttribute('data-variant-index'),
            nom: c.getAttribute('data-variant-nom'),
            hasPreview: c.querySelector('.component-preview-variant') !== null
          })),
          cardId: card.id,
          cardHTML: card.outerHTML.substring(0, 500)
        })
        
        // Fallback: afficher le code source si aucun preview n'est disponible
        componentEl.innerHTML = `<pre class="text-xs text-gray-600 whitespace-pre-wrap p-4 bg-gray-50 rounded-lg">${code.trim() || "Code source non disponible"}</pre>`
      }
    }

    // Re-rendre la navigation avec le bon bouton actif et le nom réel
    const hasSubVariants = currentVariants.some(v => v.sous_variantes && Array.isArray(v.sous_variantes))
    
    if (hasSubVariants) {
      // Pour la navigation hiérarchique, mettre à jour seulement les boutons de sous-variantes
      const navWrapper = variantsContainer.querySelector("div[data-all-variants]")
      if (navWrapper) {
        const subVariantsNavWrapper = navWrapper.querySelector("#sub-variants-nav")
        if (subVariantsNavWrapper) {
          const groupsJson = navWrapper.getAttribute("data-groups")
          if (groupsJson) {
            const groups = JSON.parse(groupsJson)
            if (groups.length > 0 && currentGroupIndex < groups.length) {
              const selectedGroup = groups[currentGroupIndex]
              const allVariantsJson = navWrapper.getAttribute("data-all-variants")
              const allVariants = allVariantsJson ? JSON.parse(allVariantsJson) : []
              updateSubVariantsNavButtons(subVariantsNavWrapper, selectedGroup.subVariants)
            }
          }
        }
      }
    } else {
      // Pour la navigation plate, re-rendre complètement
      renderVariantsNav(currentVariants, variantsContainer, principalNom, hidePrincipal)
    }
  }

  function openFromCard(card, previewDiv) {
    if (!card) return

    const title = card.getAttribute("data-component-title") || ""
    const moduleName = card.getAttribute("data-component-module") || ""
    const sousCategorie = card.getAttribute("data-component-title") || ""
    const principalCode = card.getAttribute("data-component-principal-code") || ""
    const principalNom = card.getAttribute("data-component-principal-nom") || title || ""
    const variantsJson = card.getAttribute("data-component-variantes") || "[]"

    try {
      currentVariants = JSON.parse(variantsJson)
      // Ne pas ajouter d'index ici, car renderVariantsNav va créer la structure plate
    } catch (e) {
      console.warn("Failed to parse variants:", e)
      currentVariants = []
    }

    currentVariantIndex = 0 // Toujours commencer par le principal

    // S'assurer que la card a un ID unique pour les mises à jour
    if (!card.id) {
      const tempId = "card-" + Math.random().toString(36).substr(2, 9)
      card.id = tempId
    }
    modal.setAttribute("data-current-card-id", card.id)
    modal.setAttribute("data-current-sous-categorie", sousCategorie)

    if (titleEl) titleEl.textContent = title
    if (moduleEl) moduleEl.textContent = moduleName

    // Afficher la navigation des variantes
    const hidePrincipal = sousCategorie === "Distance"
    const hasSubVariants = currentVariants.some(v => v.sous_variantes && Array.isArray(v.sous_variantes))
    
    // Réinitialiser l'index du groupe pour la navigation hiérarchique
    if (hasSubVariants) {
      currentGroupIndex = 0
    }
    
    renderVariantsNav(currentVariants, variantsContainer, principalNom, hidePrincipal)

    // Afficher le bon contenu initial dans la popup
    if (sousCategorie === "Distance" && currentVariants.length > 0) {
      // Pour Distance, on démarre directement sur la première variante ("En mètre")
      currentVariantIndex = 0
      updateVariantDisplay(currentVariants[0], currentVariants)
    } else if (hasSubVariants && currentVariants.length > 0) {
      // Pour les variantes avec sous-variantes, la navigation hiérarchique gère déjà l'affichage initial
      // Ne rien faire ici, renderHierarchicalNav s'en charge
    } else {
      // Par défaut, on démarre sur le composant principal
      const principalVariant = { nom: principalNom, code_source: principalCode, isPrincipal: true }
      updateVariantDisplay(principalVariant, [principalVariant, ...currentVariants])
    }

    modal.classList.remove("hidden")
  }

  // Ouverture au clic sur les triggers
  document.addEventListener(
    "click",
    (event) => {
      const trigger = event.target.closest("[data-ui-preview=\"true\"]")
      if (!trigger) return
      const card = trigger.closest(".ui-component-card")
      if (!card) return
      event.preventDefault()
      openFromCard(card, trigger)
    },
    true
  )

  // Fermeture par clic sur le backdrop (hors contenu)
  backdrop.addEventListener("click", (event) => {
    if (event.target === backdrop) {
      closeModal()
    }
  })

  // Fermeture via bouton
  if (closeBtn) {
    closeBtn.addEventListener("click", (event) => {
      event.preventDefault()
      closeModal()
    })
  }

  // Copie du code source
  if (copyBtn) {
    copyBtn.addEventListener("click", (event) => {
      event.preventDefault()
      if (!codeEl) return
      const code = codeEl.textContent || ""
      if (!code.trim()) {
        showFlash("danger", "Rien n'est copié car le code source n'est pas disponible")
        return
      }
      navigator.clipboard
        .writeText(code)
        .then(() => {
          showFlash("success", "Code source copié avec succès")
        })
        .catch(() => {
          showFlash("danger", "Erreur lors de la copie")
        })
    })
  }
}

// Initialiser les comportements globaux une fois le DOM prêt
function initGlobalUI() {
  initModeSwitch()
  initUiPreviewModal()
}

if (document.readyState === "loading") {
  document.addEventListener("DOMContentLoaded", initGlobalUI)
} else {
  initGlobalUI()
}

// Réinitialiser la popup après chaque mise à jour LiveView
window.addEventListener("phx:page-loading-stop", () => {
  initUiPreviewModal()
  // Réappliquer le mode après chaque mise à jour LiveView pour s'assurer que les boutons sont à jour
  applyMode(currentMode)
})

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


// Hook pour la recherche dans la bibliothèque UI
const UISearchHook = {
  mounted() {
    const searchInput = this.el
    const grid = document.getElementById("ui-components-grid")
    const iconsSection = document.getElementById("ui-icons-section")
    const noResults = document.getElementById("ui-no-results")
    
    if (!grid) return

    const filterCards = (searchTerm) => {
      const activeCategory = window.getActiveCategory ? window.getActiveCategory() : "texte-nombres"
      const activeSubcategory = window.getActiveSubcategory ? window.getActiveSubcategory() : null
      const term = searchTerm.toLowerCase().trim()
      let visibleCount = 0

      // Si on est sur la catégorie icônes, filtrer les icônes dans la section dédiée
      if (activeCategory === "icones" && iconsSection) {
        const iconCards = iconsSection.querySelectorAll(".ui-icon-card")
        iconCards.forEach((card) => {
          const title = card.getAttribute("data-component-title") || ""
          const module = card.getAttribute("data-component-module") || ""
          const matchesSearch = term === "" || 
            title.toLowerCase().includes(term) || 
            module.toLowerCase().includes(term)
          
          if (matchesSearch) {
            card.style.display = ""
            visibleCount++
          } else {
            card.style.display = "none"
          }
        })
      } else {
        // Filtrer les cards normales
        const cards = grid.querySelectorAll(".ui-component-card")
        cards.forEach((card) => {
          const cardCategory = card.getAttribute("data-component-category")
          const cardSubcategory = card.getAttribute("data-component-subcategory")
          const title = card.getAttribute("data-component-title") || ""
          const module = card.getAttribute("data-component-module") || ""
          
          const matchesCategory = cardCategory === activeCategory
          const matchesSubcategory = !activeSubcategory || cardSubcategory === activeSubcategory
          const matchesTitle = title.toLowerCase().includes(term)
          const matchesModule = module.toLowerCase().includes(term)
          const matchesSearch = term === "" || matchesTitle || matchesModule
          
          if (matchesCategory && matchesSubcategory && matchesSearch) {
            card.style.display = ""
            visibleCount++
          } else {
            card.style.display = "none"
          }
        })
      }

      // Afficher/masquer le message "Aucun résultat"
      if (noResults) {
        if (visibleCount === 0) {
          noResults.classList.remove("hidden")
        } else {
          noResults.classList.add("hidden")
        }
      }
    }

    searchInput.addEventListener("input", (e) => {
      filterCards(e.target.value)
    })

    // Filtrer au montage si une valeur existe déjà
    if (searchInput.value) {
      filterCards(searchInput.value)
    }
  }
}

Hooks.UISearch = UISearchHook

// Hook pour la recherche Spotlight dans la bibliothèque UI
const SpotlightSearchHook = {
  mounted() {
    const modal = this.el
    const trigger = document.getElementById("ui-search-trigger")
    const input = document.getElementById("ui-spotlight-input")
    const resultsList = document.getElementById("ui-spotlight-results-list")
    const noResults = document.getElementById("ui-spotlight-no-results")
    const closeButtons = modal.querySelectorAll("[data-spotlight-close]")
    
    let selectedIndex = -1
    let results = []

    const openModal = () => {
      modal.classList.remove("hidden")
      setTimeout(() => {
        input?.focus()
      }, 100)
      document.body.style.overflow = "hidden"
    }

    const closeModal = () => {
      modal.classList.add("hidden")
      if (input) input.value = ""
      selectedIndex = -1
      results = []
      document.body.style.overflow = ""
    }

    const getCategoryLabel = (category) => {
      const labels = {
        "texte-nombres": "Texte et Nombres",
        "basiques": "Basiques",
        "dates-heures": "Dates et heures",
        "cartes": "Cartes",
        "formulaire": "Formulaire",
        "icones": "Icônes"
      }
      return labels[category] || category
    }

    const searchAllComponents = (term) => {
      if (!term || term.trim().length === 0) {
        results = []
        renderResults()
        return
      }

      const searchTerm = term.toLowerCase().trim()
      results = []
      const grid = document.getElementById("ui-components-grid")
      const iconsSection = document.getElementById("ui-icons-section")

      // Rechercher dans les cards normales
      if (grid) {
        const cards = grid.querySelectorAll(".ui-component-card")
        cards.forEach((card) => {
          const title = card.getAttribute("data-component-title") || ""
          const module = card.getAttribute("data-component-module") || ""
          const category = card.getAttribute("data-component-category") || ""
          const subcategory = card.getAttribute("data-component-subcategory")
          const cardId = card.id || ""
          
          const matchesTitle = title.toLowerCase().includes(searchTerm)
          const matchesModule = module.toLowerCase().includes(searchTerm)
          
          if (matchesTitle || matchesModule) {
            results.push({
              id: cardId,
              title: title,
              category: category,
              subcategory: subcategory,
              type: "component",
              element: card
            })
          }
        })
      }

      // Rechercher dans les icônes
      if (iconsSection) {
        const iconCards = iconsSection.querySelectorAll(".ui-icon-card")
        iconCards.forEach((card) => {
          const title = card.getAttribute("data-component-title") || ""
          const module = card.getAttribute("data-component-module") || ""
          
          const matchesTitle = title.toLowerCase().includes(searchTerm)
          const matchesModule = module.toLowerCase().includes(searchTerm)
          
          if (matchesTitle || matchesModule) {
            results.push({
              id: card.id || "",
              title: title,
              category: "icones",
              subcategory: null,
              type: "icon",
              element: card
            })
          }
        })
      }

      renderResults()
    }

    const renderResults = () => {
      if (!resultsList || !noResults) return

      if (results.length === 0) {
        resultsList.innerHTML = ""
        noResults.classList.remove("hidden")
        return
      }

      noResults.classList.add("hidden")
      resultsList.innerHTML = results.map((result, index) => `
        <button
          type="button"
          class="w-full text-left px-4 py-3 rounded-lg hover:bg-gray-100 transition-colors flex items-center justify-between group ${index === selectedIndex ? 'bg-gray-100' : ''}"
          data-result-index="${index}"
          data-result-id="${result.id}"
          data-result-category="${result.category}"
          data-result-subcategory="${result.subcategory || ''}"
        >
          <div class="flex-1 min-w-0">
            <div class="font-medium text-gray-900 truncate">${result.title}</div>
            <div class="text-sm text-gray-500 truncate">${getCategoryLabel(result.category)}</div>
          </div>
          <svg class="w-5 h-5 text-gray-400 opacity-0 group-hover:opacity-100 transition-opacity" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
          </svg>
        </button>
      `).join("")

      // Ajouter les event listeners
      resultsList.querySelectorAll("button[data-result-index]").forEach((btn) => {
        btn.addEventListener("click", () => {
          const index = parseInt(btn.getAttribute("data-result-index"))
          selectResult(index)
        })
      })
    }

    const selectResult = (index) => {
      if (index < 0 || index >= results.length) return

      const result = results[index]
      closeModal()

      // Ouvrir la catégorie correspondante
      const sidebar = document.getElementById("ui-categories-sidebar")
      if (sidebar) {
        // Accéder au hook via l'élément
        const hookEl = sidebar
        const hookId = hookEl.getAttribute("data-phx-hook")
        if (hookId === "UICategory") {
          // Utiliser la fonction exposée sur window
          if (window.setActiveCategory) {
            window.setActiveCategory(result.category, result.subcategory)
          } else {
            // Fallback: trouver le hook via liveSocket
            if (window.liveSocket) {
              const hooks = window.liveSocket.hooks || {}
              const hook = hooks.UICategory
              if (hook && hook.setActiveCategory) {
                hook.setActiveCategory(result.category, result.subcategory)
              }
            }
          }
        }
      }

      // Attendre que la catégorie soit ouverte puis scroller vers le composant
      setTimeout(() => {
        const element = result.element
        if (element) {
          // S'assurer que l'élément est visible
          element.style.display = ""
          
          // Scroller vers l'élément avec animation
          element.scrollIntoView({
            behavior: "smooth",
            block: "center"
          })

          // Ajouter un effet de surbrillance temporaire
          element.classList.add("ring-2", "ring-blue-500", "ring-offset-2")
          setTimeout(() => {
            element.classList.remove("ring-2", "ring-blue-500", "ring-offset-2")
          }, 2000)
        }
      }, 300)
    }

    // Event listeners
    trigger?.addEventListener("click", openModal)
    closeButtons.forEach(btn => btn.addEventListener("click", closeModal))
    
    input?.addEventListener("input", (e) => {
      searchAllComponents(e.target.value)
      selectedIndex = -1
    })

    input?.addEventListener("keydown", (e) => {
      if (e.key === "Escape") {
        closeModal()
      } else if (e.key === "ArrowDown") {
        e.preventDefault()
        selectedIndex = Math.min(selectedIndex + 1, results.length - 1)
        renderResults()
        const selectedBtn = resultsList.querySelector(`[data-result-index="${selectedIndex}"]`)
        selectedBtn?.scrollIntoView({ block: "nearest", behavior: "smooth" })
      } else if (e.key === "ArrowUp") {
        e.preventDefault()
        selectedIndex = Math.max(selectedIndex - 1, -1)
        renderResults()
        if (selectedIndex >= 0) {
          const selectedBtn = resultsList.querySelector(`[data-result-index="${selectedIndex}"]`)
          selectedBtn?.scrollIntoView({ block: "nearest", behavior: "smooth" })
        }
      } else if (e.key === "Enter" && selectedIndex >= 0) {
        e.preventDefault()
        selectResult(selectedIndex)
      }
    })

    // Raccourci clavier ⌘K ou Ctrl+K
    document.addEventListener("keydown", (e) => {
      if ((e.metaKey || e.ctrlKey) && e.key === "k") {
        e.preventDefault()
        if (modal.classList.contains("hidden")) {
          openModal()
        } else {
          closeModal()
        }
      }
    })
  }
}

Hooks.SpotlightSearch = SpotlightSearchHook
    const grid = document.getElementById("ui-components-grid")
    const noResults = document.getElementById("ui-no-results")
    
    if (grid && searchInput.value) {
      const cards = grid.querySelectorAll(".ui-component-card")
      const term = searchInput.value.toLowerCase().trim()
      let visibleCount = 0

      const activeCategory = window.getActiveCategory ? window.getActiveCategory() : "texte-nombres"
      const activeSubcategory = window.getActiveSubcategory ? window.getActiveSubcategory() : null

      cards.forEach((card) => {
        const cardCategory = card.getAttribute("data-component-category")
        const cardSubcategory = card.getAttribute("data-component-subcategory")
        const title = card.getAttribute("data-component-title") || ""
        const module = card.getAttribute("data-component-module") || ""
        
        const matchesCategory = cardCategory === activeCategory
        const matchesSubcategory = !activeSubcategory || cardSubcategory === activeSubcategory
        const matchesTitle = title.toLowerCase().includes(term)
        const matchesModule = module.toLowerCase().includes(term)
        const matchesSearch = term === "" || matchesTitle || matchesModule
        
        if (matchesCategory && matchesSubcategory && matchesSearch) {
          card.style.display = ""
          visibleCount++
        } else {
          card.style.display = "none"
        }
      })

      // Afficher/masquer le message "Aucun résultat"
      if (noResults) {
        if (visibleCount === 0) {
          noResults.classList.remove("hidden")
        } else {
          noResults.classList.add("hidden")
        }
      }
    }
  }
}

// Fonction globale pour obtenir la catégorie active
window.getActiveCategory = () => {
  const nav = document.getElementById("ui-categories-nav")
  if (!nav) return "texte-nombres"
  
  const activeBtn = nav.querySelector(".ui-category-btn.bg-gray-900")
  return activeBtn ? activeBtn.getAttribute("data-category") : "texte-nombres"
}

// Fonction globale pour obtenir la sous-catégorie active
window.getActiveSubcategory = () => {
  const nav = document.getElementById("ui-categories-nav")
  if (!nav) return null
  
  const activeSubBtn = nav.querySelector(".ui-subcategory-btn.bg-gray-100")
  return activeSubBtn ? activeSubBtn.getAttribute("data-subcategory") : null
}

// Hook pour gérer les catégories dans la bibliothèque UI
const UICategoryHook = {
  mounted() {
    const nav = document.getElementById("ui-categories-nav")
    if (!nav) return

    let activeCategory = "texte-nombres" // Catégorie par défaut
    let activeSubcategory = null

    const filterByCategory = (category, subcategory = null, searchTerm = "") => {
      const grid = document.getElementById("ui-components-grid")
      const iconsSection = document.getElementById("ui-icons-section")
      
      // Gérer l'affichage de la section des icônes
      if (iconsSection) {
        if (category === "icones") {
          iconsSection.classList.remove("hidden")
          if (grid) grid.style.display = "none"
        } else {
          iconsSection.classList.add("hidden")
          if (grid) grid.style.display = ""
        }
      }

      if (!grid) return

      const cards = grid.querySelectorAll(".ui-component-card")
      const term = searchTerm.toLowerCase().trim()
      let visibleCount = 0

      // Si on est sur la catégorie icônes, filtrer les icônes dans la section dédiée
      if (category === "icones" && iconsSection) {
        const iconCards = iconsSection.querySelectorAll(".ui-icon-card")
        iconCards.forEach((card) => {
          const title = card.getAttribute("data-component-title") || ""
          const module = card.getAttribute("data-component-module") || ""
          const matchesSearch = term === "" || 
            title.toLowerCase().includes(term) || 
            module.toLowerCase().includes(term)
          
          if (matchesSearch) {
            card.style.display = ""
            visibleCount++
          } else {
            card.style.display = "none"
          }
        })
      } else {
        // Filtrer les cards normales
        cards.forEach((card) => {
          const cardCategory = card.getAttribute("data-component-category")
          const cardSubcategory = card.getAttribute("data-component-subcategory")
          const title = card.getAttribute("data-component-title") || ""
          const module = card.getAttribute("data-component-module") || ""
          
          const matchesCategory = cardCategory === category
          const matchesSubcategory = !subcategory || cardSubcategory === subcategory
          const matchesSearch = term === "" || 
            title.toLowerCase().includes(term) || 
            module.toLowerCase().includes(term)
          
          if (matchesCategory && matchesSubcategory && matchesSearch) {
            card.style.display = ""
            visibleCount++
          } else {
            card.style.display = "none"
          }
        })
      }

      // Gérer le message "Aucun résultat"
      const noResults = document.getElementById("ui-no-results")
      if (noResults) {
        if (visibleCount === 0) {
          noResults.classList.remove("hidden")
        } else {
          noResults.classList.add("hidden")
        }
      }
    }

    const setActiveCategory = (category, subcategory = null) => {
      activeCategory = category
      activeSubcategory = subcategory
      
      // Afficher/masquer les sous-catégories pour Basiques
      const subcategoriesContainer = document.getElementById("basiques-subcategories")
      if (subcategoriesContainer) {
        if (category === "basiques") {
          subcategoriesContainer.classList.remove("hidden")
        } else {
          subcategoriesContainer.classList.add("hidden")
        }
      }
      
      // Mettre à jour le style des boutons de catégorie
      const buttons = nav.querySelectorAll(".ui-category-btn")
      buttons.forEach((btn) => {
        const btnCategory = btn.getAttribute("data-category")
        if (btnCategory === category) {
          btn.className = "ui-category-btn w-full text-left px-3 py-2 rounded-md bg-gray-900 text-white text-xs md:text-sm shadow-sm transition-colors"
        } else {
          btn.className = "ui-category-btn w-full text-left px-3 py-2 rounded-md text-xs md:text-sm text-gray-700 hover:bg-gray-100 transition-colors"
        }
      })

      // Mettre à jour le style des boutons de sous-catégorie
      const subcategoryButtons = nav.querySelectorAll(".ui-subcategory-btn")
      subcategoryButtons.forEach((btn) => {
        const btnSubcategory = btn.getAttribute("data-subcategory")
        if (category === "basiques" && btnSubcategory === subcategory) {
          btn.className = "ui-subcategory-btn w-full text-left px-3 py-1.5 rounded-md text-xs bg-gray-100 text-gray-900 font-medium transition-colors"
        } else {
          btn.className = "ui-subcategory-btn w-full text-left px-3 py-1.5 rounded-md text-xs text-gray-600 hover:bg-gray-50 hover:text-gray-900 transition-colors"
        }
      })

      // Filtrer les cards selon la catégorie, sous-catégorie et la recherche active
      const searchInput = document.getElementById("ui-search")
      const searchTerm = searchInput ? searchInput.value : ""
      filterByCategory(category, subcategory, searchTerm)
    }

    // Ajouter les event listeners aux boutons de catégorie
    const buttons = nav.querySelectorAll(".ui-category-btn")
    buttons.forEach((btn) => {
      btn.addEventListener("click", (e) => {
        e.preventDefault()
        const category = btn.getAttribute("data-category")
        setActiveCategory(category, null)
      })
    })

    // Ajouter les event listeners aux boutons de sous-catégorie
    const subcategoryButtons = nav.querySelectorAll(".ui-subcategory-btn")
    subcategoryButtons.forEach((btn) => {
      btn.addEventListener("click", (e) => {
        e.preventDefault()
        const category = btn.getAttribute("data-category")
        const subcategory = btn.getAttribute("data-subcategory")
        setActiveCategory(category, subcategory)
      })
    })

    // Initialiser avec la catégorie par défaut
    setActiveCategory(activeCategory, null)
    
    // Exposer la fonction pour le hook de recherche
    this.setActiveCategory = setActiveCategory
    this.getActiveCategory = () => activeCategory
    this.getActiveSubcategory = () => activeSubcategory
    
    // Exposer aussi sur window pour le SpotlightSearchHook
    window.setActiveCategory = setActiveCategory
    window.getActiveCategory = () => activeCategory
    window.getActiveSubcategory = () => activeSubcategory
  }
}

// Hook pour gérer la grille Bento adaptative
const BentoGrid = {
  mounted() {
    this.adjustBentoGrid()
    // Réajuster après les changements de catégorie ou de recherche
    const observer = new MutationObserver(() => {
      this.adjustBentoGrid()
    })
    observer.observe(this.el, { childList: true, subtree: true, attributes: true, attributeFilter: ['style', 'class'] })
  },
  
  updated() {
    this.adjustBentoGrid()
  },
  
  adjustBentoGrid() {
    const grid = this.el
    if (!grid) return
    
    // Attendre que le layout soit stabilisé
    setTimeout(() => {
      // Ne s'applique qu'en mode xl (3 colonnes)
      if (window.innerWidth < 1280) return
      
      const allCards = Array.from(grid.querySelectorAll('.ui-component-card'))
        .filter(c => window.getComputedStyle(c).display !== 'none')
      
      if (allCards.length === 0) return
      
      // Organiser les cards par lignes
      const cardsByLine = this.organizeCardsByLine(allCards)
      
      // Optimiser chaque ligne
      cardsByLine.forEach((lineCards) => {
        this.optimizeLine(lineCards, allCards, cardsByLine)
      })
    }, 150)
  },
  
  organizeCardsByLine(cards) {
    const lines = []
    const processed = new Set()
    
    cards.forEach(card => {
      if (processed.has(card)) return
      
      const cardRect = card.getBoundingClientRect()
      const line = [card]
      processed.add(card)
      
      // Trouver toutes les cards sur la même ligne
      cards.forEach(otherCard => {
        if (processed.has(otherCard)) return
        const otherRect = otherCard.getBoundingClientRect()
        if (Math.abs(otherRect.top - cardRect.top) < 5) {
          line.push(otherCard)
          processed.add(otherCard)
        }
      })
      
      // Trier par position horizontale
      line.sort((a, b) => {
        const aRect = a.getBoundingClientRect()
        const bRect = b.getBoundingClientRect()
        return aRect.left - bRect.left
      })
      
      lines.push(line)
    })
    
    return lines.sort((a, b) => {
      const aTop = a[0].getBoundingClientRect().top
      const bTop = b[0].getBoundingClientRect().top
      return aTop - bTop
    })
  },
  
  getCardSpan(card) {
    if (card.classList.contains('xl:col-span-3')) return 3
    if (card.classList.contains('xl:col-span-2')) return 2
    return 1
  },
  
  setCardSpan(card, span) {
    card.classList.remove('xl:col-span-2', 'xl:col-span-3')
    if (span === 2) {
      card.classList.add('xl:col-span-2')
    } else if (span === 3) {
      card.classList.add('xl:col-span-3')
    }
  },
  
  optimizeLine(lineCards, allCards, allLines) {
    // Calculer l'espace occupé sur cette ligne
    let occupiedSpace = 0
    lineCards.forEach(card => {
      occupiedSpace += this.getCardSpan(card)
    })
    
    // Si la ligne est complète (3 colonnes), ne rien faire
    if (occupiedSpace >= 3) return
    
    const currentLineIndex = allLines.findIndex(line => line === lineCards)
    
    // Cas 1: Une card de 2 colonnes est seule sur sa ligne
    if (occupiedSpace === 2 && lineCards.length === 1) {
      const card = lineCards[0]
      const cardSpan = this.getCardSpan(card)
      
      if (cardSpan === 2) {
        // Chercher une card de 1 colonne dans les lignes suivantes qui peut être combinée
        const nextSingleCard = this.findNextSingleCard(allLines, currentLineIndex)
        
        if (nextSingleCard) {
          // Utiliser grid-column pour positionner la card suivante sur la même ligne
          // En utilisant order CSS, on peut réorganiser visuellement
          card.style.order = currentLineIndex * 100
          nextSingleCard.card.style.order = currentLineIndex * 100 + 1
          
          // S'assurer que les spans sont corrects
          this.setCardSpan(card, 2)
          this.setCardSpan(nextSingleCard.card, 1)
          return
        }
        
        // Si aucune card de 1 colonne ne peut être combinée, étendre à 3 colonnes
        this.setCardSpan(card, 3)
      }
    }
    
    // Cas 2: Deux cards de 1 colonne sur la même ligne
    if (occupiedSpace === 2 && lineCards.length === 2) {
      const bothSingle = lineCards.every(c => this.getCardSpan(c) === 1)
      if (bothSingle) {
        // Chercher une troisième card de 1 colonne pour compléter la ligne
        const nextSingleCard = this.findNextSingleCard(allLines, currentLineIndex)
        
        if (nextSingleCard) {
          lineCards.forEach((c, idx) => {
            c.style.order = currentLineIndex * 100 + idx
          })
          nextSingleCard.card.style.order = currentLineIndex * 100 + 2
          
          this.setCardSpan(nextSingleCard.card, 1)
          return
        }
      }
    }
    
    // Cas 3: Une card de 1 colonne seule sur sa ligne
    if (occupiedSpace === 1 && lineCards.length === 1) {
      const card = lineCards[0]
      const cardSpan = this.getCardSpan(card)
      
      if (cardSpan === 1) {
        // Chercher une card de 2 colonnes dans les lignes suivantes
        const nextDoubleCard = this.findNextDoubleCard(allLines, currentLineIndex)
        
        if (nextDoubleCard) {
          card.style.order = currentLineIndex * 100
          nextDoubleCard.card.style.order = currentLineIndex * 100 + 1
          
          this.setCardSpan(card, 1)
          this.setCardSpan(nextDoubleCard.card, 2)
          return
        }
      }
    }
  },
  
  findNextSingleCard(allLines, currentLineIndex) {
    for (let i = currentLineIndex + 1; i < allLines.length; i++) {
      const line = allLines[i]
      const lineOccupied = line.reduce((sum, c) => sum + this.getCardSpan(c), 0)
      
      // Chercher une card de 1 colonne dans cette ligne
      const singleCard = line.find(c => this.getCardSpan(c) === 1)
      
      if (singleCard) {
        // Si la ligne peut se permettre de perdre cette card (elle a d'autres cards ou plus d'espace)
        if (line.length > 1 || lineOccupied > 1) {
          return { card: singleCard, lineIndex: i }
        }
      }
    }
    return null
  },
  
  findNextDoubleCard(allLines, currentLineIndex) {
    for (let i = currentLineIndex + 1; i < allLines.length; i++) {
      const line = allLines[i]
      const lineOccupied = line.reduce((sum, c) => sum + this.getCardSpan(c), 0)
      
      // Chercher une card de 2 colonnes dans cette ligne
      const doubleCard = line.find(c => this.getCardSpan(c) === 2)
      
      if (doubleCard) {
        // Si la ligne peut se permettre de perdre cette card
        if (line.length > 1 || lineOccupied > 2) {
          return { card: doubleCard, lineIndex: i }
        }
      }
    }
    return null
  }
}

// Handler pour copier le code dans le presse-papiers
document.addEventListener("phx:code_copied", (event) => {
  const { code, success } = event.detail
  if (success && code) {
    navigator.clipboard.writeText(code).then(() => {
      showFlash("success", "Code source copié avec succès")
    }).catch(() => {
      showFlash("danger", "Erreur lors de la copie")
    })
  } else {
    showFlash("danger", "Rien n'est copié car le code source n'est pas disponible")
  }
})

// Hook pour gérer les boutons mode-toggle dans le header
const ModeSwitchHook = {
  mounted() {
    this.handleClick = (event) => {
      // Vérifier si le clic vient d'un bouton mode-toggle
      let btn = event.target.closest("[data-mode-toggle]")
      
      if (!btn) return
      
      event.preventDefault()
      event.stopPropagation()
      event.stopImmediatePropagation()
      
      const explicitValue = btn.getAttribute("data-mode-value")
      let nextMode = explicitValue

      if (!nextMode) {
        nextMode = currentMode === "demo" ? "ui" : "demo"
      }

      if (nextMode && nextMode !== currentMode) {
        applyMode(nextMode)
      }
      
      return false
    }
    
    // Utiliser la délégation d'événements sur l'élément parent
    this.el.addEventListener("click", this.handleClick, true)
    
    // Réappliquer le mode après le montage
    setTimeout(() => {
      applyMode(currentMode)
    }, 100)
  },
  
  updated() {
    // Réappliquer le mode après la mise à jour
    setTimeout(() => {
      applyMode(currentMode)
    }, 100)
  },
  
  destroyed() {
    // Nettoyer le listener
    if (this.handleClick) {
      this.el.removeEventListener("click", this.handleClick, true)
    }
  }
}

const hooks = {
  ...colocatedHooks,
  ThemeManager: ThemeManagerHook,
  ContextMenuNotification: ContextMenuNotificationHook,
  UISearch: UISearchHook,
  UICategory: UICategoryHook,
  BentoGrid: BentoGrid,
  ModeSwitch: ModeSwitchHook
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

// Hook pour ajuster automatiquement la taille des cards en fonction du débordement
const AutoResizeCardHook = {
  mounted() {
    this.checkOverflowDebounced = this.debounce(() => this.checkOverflow(), 100)
    this.checkOverflow()
    
    // Observer les changements de taille du contenu
    this.observer = new MutationObserver(() => {
      this.checkOverflowDebounced()
    })
    this.observer.observe(this.el, {
      childList: true,
      subtree: true,
      attributes: true,
      attributeFilter: ['class', 'style']
    })
    
    // Observer aussi les changements de taille de la fenêtre
    this.resizeHandler = () => {
      setTimeout(() => this.checkOverflow(), 100)
    }
    window.addEventListener('resize', this.resizeHandler)
  },

  updated() {
    this.checkOverflowDebounced()
  },

  destroyed() {
    if (this.observer) {
      this.observer.disconnect()
    }
    if (this.resizeHandler) {
      window.removeEventListener('resize', this.resizeHandler)
    }
  },

  debounce(func, wait) {
    let timeout
    return function executedFunction(...args) {
      const later = () => {
        clearTimeout(timeout)
        func(...args)
      }
      clearTimeout(timeout)
      timeout = setTimeout(later, wait)
    }
  },

  checkOverflow() {
    const card = this.el
    const previewTrigger = card.querySelector('.ui-preview-trigger')
    if (!previewTrigger) return

    // Attendre que le DOM soit stabilisé
    requestAnimationFrame(() => {
      const cardRect = card.getBoundingClientRect()
      const previewRect = previewTrigger.getBoundingClientRect()
      
      // Vérifier le débordement horizontal (avec une petite marge pour éviter les problèmes de rendu)
      const horizontalOverflow = previewRect.width > (cardRect.width - 10)
      // Vérifier le débordement vertical
      const verticalOverflow = previewRect.height > (cardRect.height - 10)

      if (horizontalOverflow) {
        this.expandCardHorizontally()
      }
      
      if (verticalOverflow) {
        this.expandCardVertically()
      }
    })
  },

  expandCardHorizontally() {
    const card = this.el
    const previewTrigger = card.querySelector('.ui-preview-trigger')
    if (!previewTrigger) return

    const maxColSpan = 12 // Maximum de colonnes dans une grille Tailwind standard
    const grid = card.closest('#ui-components-grid')
    if (!grid) return

    // Expansion progressive jusqu'à résolution du débordement
    const tryExpand = (currentColSpan) => {
      const cardRect = card.getBoundingClientRect()
      const previewRect = previewTrigger.getBoundingClientRect()
      const overflow = previewRect.width > (cardRect.width - 10)

      if (overflow && currentColSpan < maxColSpan) {
        const newColSpan = currentColSpan + 1
        this.setColSpan(card, newColSpan)
        
        // Vérifier à nouveau après un court délai pour laisser le DOM se mettre à jour
        setTimeout(() => {
          const newCardRect = card.getBoundingClientRect()
          const newPreviewRect = previewTrigger.getBoundingClientRect()
          const stillOverflowing = newPreviewRect.width > (newCardRect.width - 10)
          
          if (stillOverflowing && newColSpan < maxColSpan) {
            tryExpand(newColSpan)
          }
        }, 50)
      }
    }

    const initialColSpan = this.getCurrentColSpan(card)
    tryExpand(initialColSpan)
  },

  expandCardVertically() {
    const card = this.el
    const previewTrigger = card.querySelector('.ui-preview-trigger')
    if (!previewTrigger) return

    const cardRect = card.getBoundingClientRect()
    const previewRect = previewTrigger.getBoundingClientRect()
    const neededHeight = previewRect.height + 40 // Ajouter un peu de padding (p-6 = 24px de chaque côté)
    
    // Ne définir minHeight que si nécessaire
    const currentMinHeight = parseInt(card.style.minHeight) || 0
    if (neededHeight > currentMinHeight) {
      card.style.minHeight = `${neededHeight}px`
    }
  },

  getCurrentColSpan(card) {
    const classes = card.className.split(' ')
    let maxSpan = 1
    
    // Chercher les classes col-span (prendre la plus grande valeur)
    for (const cls of classes) {
      // Chercher dans les classes responsive (md: et xl:)
      const mdMatch = cls.match(/md:col-span-(\d+)/)
      if (mdMatch) {
        maxSpan = Math.max(maxSpan, parseInt(mdMatch[1], 10))
      }
      const xlMatch = cls.match(/xl:col-span-(\d+)/)
      if (xlMatch) {
        maxSpan = Math.max(maxSpan, parseInt(xlMatch[1], 10))
      }
      // Chercher aussi les classes non-responsive
      const spanMatch = cls.match(/col-span-(\d+)/)
      if (spanMatch && !cls.includes('md:') && !cls.includes('xl:')) {
        maxSpan = Math.max(maxSpan, parseInt(spanMatch[1], 10))
      }
    }
    
    return maxSpan
  },

  setColSpan(card, colSpan) {
    // Retirer les anciennes classes col-span
    card.className = card.className
      .replace(/\b(col-span-\d+|md:col-span-\d+|xl:col-span-\d+)\b/g, '')
      .trim()
    
    // Ajouter la nouvelle classe
    if (colSpan > 1) {
      card.classList.add(`md:col-span-${colSpan}`, `xl:col-span-${colSpan}`)
    }
  }
}

Hooks.AutoResizeCard = AutoResizeCardHook

