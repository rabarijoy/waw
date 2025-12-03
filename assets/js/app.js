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
  body.dataset.appMode = mode

  const navWrapper = document.getElementById("app-main-nav")
  const mainContent = document.getElementById("app-main-content")
  const uiPanel = document.getElementById("ui-library-panel")

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
      window.requestAnimationFrame(() => {
        uiPanel.classList.remove("opacity-0")
      })
    } else {
      uiPanel.classList.add("opacity-0")
      uiPanel.classList.add("hidden")
      mainContent.classList.remove("hidden")
    }
  }
}

function initModeSwitch() {
  // Appliquer le mode courant sur le DOM actuel
  applyMode(currentMode)

  // Délégation globale pour tous les boutons Demo/UI (desktop + mobile)
  if (!window.wawModeSwitchInitialized) {
    document.addEventListener(
      "click",
      (event) => {
        const btn = event.target.closest("[data-mode-toggle]")
        if (!btn) return
        // Si le clic est déclenché depuis un élément à l'intérieur de la popup UI, l'ignorer
        if (event.target.closest("#ui-preview-modal")) return
        
        event.preventDefault()

        const explicitValue = btn.getAttribute("data-mode-value")
        let nextMode = explicitValue

        // Si aucun value explicite, on toggle simplement
        if (!nextMode) {
          nextMode = currentMode === "demo" ? "ui" : "demo"
        }

        if (nextMode && nextMode !== currentMode) {
          applyMode(nextMode)
        }
      },
      true
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
  if (!uiPanel) return

  // Intercepter tous les clics sur les liens dans la zone UI
  uiPanel.addEventListener("click", (event) => {
    // Trouver le lien le plus proche (a, ou élément avec href/navigate)
    const link = event.target.closest("a, [href], [navigate], [data-navigate]")
    if (!link) return

    // Vérifier si c'est un vrai lien (pas juste un élément avec un attribut vide)
    const href = link.getAttribute("href")
    const navigate = link.getAttribute("navigate")
    const dataNavigate = link.getAttribute("data-navigate")
    
    // Si c'est un lien vers #, une route, ou un navigate, bloquer
    if (href || navigate || dataNavigate) {
      event.preventDefault()
      event.stopPropagation()
      event.stopImmediatePropagation()
      return false
    }
  }, true) // Utiliser capture pour intercepter avant que Phoenix ne gère le clic
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

  function closeModal() {
    modal.classList.add("hidden")
    currentVariants = []
    currentVariantIndex = 0
  }

  function renderVariantsNav(variants, container, principalNom) {
    if (!container) return
    
    // Créer le bouton avec le nom réel du composant principal
    const allVariants = [
      { nom: principalNom || "Principal", code_source: null, isPrincipal: true },
      ...variants.map(v => ({ ...v, isPrincipal: false }))
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
      
      // Utiliser le texte complet mais avec truncate CSS pour gérer l'affichage
      const displayText = variant.nom || principalNom || "Principal"
      btn.textContent = displayText
      btn.title = displayText // Tooltip avec le nom complet pour voir le texte entier
      
      // Ajouter un style pour s'assurer que le texte est tronqué avec ellipsis
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
    if (!cardId) return
    
    const card = document.getElementById(cardId)
    if (!card) return

    const principalCode = card.getAttribute("data-component-principal-code") || ""
    const principalNom = card.getAttribute("data-component-principal-nom") || card.getAttribute("data-component-title") || ""
    const code = variant.isPrincipal ? principalCode : (variant.code_source || "")

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
      // Pour les variantes, afficher le code source pour l'instant
      // TODO: Plus tard, rendre les variantes aussi
      componentEl.innerHTML = `<pre class="text-xs text-gray-600 whitespace-pre-wrap p-4 bg-gray-50 rounded-lg">${code.trim() || "Code source non disponible"}</pre>`
    }

    // Re-rendre la navigation avec le bon bouton actif et le nom réel
    renderVariantsNav(currentVariants, variantsContainer, principalNom)
  }

  function openFromCard(card, previewDiv) {
    if (!card) return

    const title = card.getAttribute("data-component-title") || ""
    const moduleName = card.getAttribute("data-component-module") || ""
    const principalCode = card.getAttribute("data-component-principal-code") || ""
    const variantsJson = card.getAttribute("data-component-variantes") || "[]"

    try {
      currentVariants = JSON.parse(variantsJson)
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

    if (titleEl) titleEl.textContent = title
    if (moduleEl) moduleEl.textContent = moduleName

    // Afficher la navigation des variantes
    renderVariantsNav(currentVariants, variantsContainer)

    // Afficher le composant principal avec le nom réel
    const principalVariant = { nom: principalNom, code_source: principalCode, isPrincipal: true }
    updateVariantDisplay(principalVariant, [principalVariant, ...currentVariants])

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
    const noResults = document.getElementById("ui-no-results")
    
    if (!grid) return

    const filterCards = (searchTerm) => {
      const cards = grid.querySelectorAll(".ui-component-card")
      const term = searchTerm.toLowerCase().trim()
      const activeCategory = window.getActiveCategory ? window.getActiveCategory() : "texte-nombres"
      let visibleCount = 0

      cards.forEach((card) => {
        const cardCategory = card.getAttribute("data-component-category")
        const title = card.getAttribute("data-component-title") || ""
        const module = card.getAttribute("data-component-module") || ""
        
        const matchesCategory = cardCategory === activeCategory
        const matchesTitle = title.toLowerCase().includes(term)
        const matchesModule = module.toLowerCase().includes(term)
        const matchesSearch = term === "" || matchesTitle || matchesModule
        
        if (matchesCategory && matchesSearch) {
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

    searchInput.addEventListener("input", (e) => {
      filterCards(e.target.value)
    })

    // Filtrer au montage si une valeur existe déjà
    if (searchInput.value) {
      filterCards(searchInput.value)
    }
  },

  updated() {
    // Re-filtrer après mise à jour du DOM
    const searchInput = this.el
    const grid = document.getElementById("ui-components-grid")
    const noResults = document.getElementById("ui-no-results")
    
    if (grid && searchInput.value) {
      const cards = grid.querySelectorAll(".ui-component-card")
      const term = searchInput.value.toLowerCase().trim()
      let visibleCount = 0

      const activeCategory = window.getActiveCategory ? window.getActiveCategory() : "texte-nombres"

      cards.forEach((card) => {
        const cardCategory = card.getAttribute("data-component-category")
        const title = card.getAttribute("data-component-title") || ""
        const module = card.getAttribute("data-component-module") || ""
        
        const matchesCategory = cardCategory === activeCategory
        const matchesTitle = title.toLowerCase().includes(term)
        const matchesModule = module.toLowerCase().includes(term)
        const matchesSearch = term === "" || matchesTitle || matchesModule
        
        if (matchesCategory && matchesSearch) {
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

// Hook pour gérer les catégories dans la bibliothèque UI
const UICategoryHook = {
  mounted() {
    const nav = document.getElementById("ui-categories-nav")
    if (!nav) return

    let activeCategory = "texte-nombres" // Catégorie par défaut

    const filterByCategory = (category, searchTerm = "") => {
      const grid = document.getElementById("ui-components-grid")
      if (!grid) return

      const cards = grid.querySelectorAll(".ui-component-card")
      const term = searchTerm.toLowerCase().trim()
      let visibleCount = 0

      cards.forEach((card) => {
        const cardCategory = card.getAttribute("data-component-category")
        const title = card.getAttribute("data-component-title") || ""
        const module = card.getAttribute("data-component-module") || ""
        
        const matchesCategory = cardCategory === category
        const matchesSearch = term === "" || 
          title.toLowerCase().includes(term) || 
          module.toLowerCase().includes(term)
        
        if (matchesCategory && matchesSearch) {
          card.style.display = ""
          visibleCount++
        } else {
          card.style.display = "none"
        }
      })

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

    const setActiveCategory = (category) => {
      activeCategory = category
      
      // Mettre à jour le style des boutons
      const buttons = nav.querySelectorAll(".ui-category-btn")
      buttons.forEach((btn) => {
        const btnCategory = btn.getAttribute("data-category")
        if (btnCategory === category) {
          btn.className = "ui-category-btn w-full text-left px-3 py-2 rounded-md bg-gray-900 text-white text-xs md:text-sm shadow-sm transition-colors"
        } else {
          btn.className = "ui-category-btn w-full text-left px-3 py-2 rounded-md text-xs md:text-sm text-gray-700 hover:bg-gray-100 transition-colors"
        }
      })

      // Filtrer les cards selon la catégorie et la recherche active
      const searchInput = document.getElementById("ui-search")
      const searchTerm = searchInput ? searchInput.value : ""
      filterByCategory(category, searchTerm)
    }

    // Ajouter les event listeners aux boutons
    const buttons = nav.querySelectorAll(".ui-category-btn")
    buttons.forEach((btn) => {
      btn.addEventListener("click", (e) => {
        e.preventDefault()
        const category = btn.getAttribute("data-category")
        setActiveCategory(category)
      })
    })

    // Initialiser avec la catégorie par défaut
    setActiveCategory(activeCategory)
    
    // Exposer la fonction pour le hook de recherche
    this.setActiveCategory = setActiveCategory
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
      const wideCards = Array.from(grid.querySelectorAll('.bento-wide'))
      if (wideCards.length === 0) return
      
      // Pour chaque carte large, vérifier si elle est seule sur sa ligne
      wideCards.forEach((card) => {
        const cardRect = card.getBoundingClientRect()
        
        // Trouver toutes les cartes visibles dans la grille
        const allCards = Array.from(grid.querySelectorAll('.ui-component-card'))
          .filter(c => window.getComputedStyle(c).display !== 'none')
        
        // Trouver les cartes sur la même ligne (même top avec une tolérance)
        const sameLineCards = allCards.filter(c => {
          if (c === card) return false
          const cRect = c.getBoundingClientRect()
          return Math.abs(cRect.top - cardRect.top) < 5
        })
        
        // Si aucune carte n'est sur la même ligne OU si la carte est la dernière de sa ligne
        // et qu'il n'y a qu'une colonne libre à droite, prendre toute la largeur
        if (sameLineCards.length === 0) {
          // Seule sur sa ligne, prendre toute la largeur
          card.classList.remove('xl:col-span-2')
          card.classList.add('xl:col-span-3')
        } else {
          // Vérifier si la carte est à la fin de sa ligne (pas de carte à droite)
          const cardsToRight = sameLineCards.filter(c => {
            const cRect = c.getBoundingClientRect()
            return cRect.left > cardRect.right + 10 // Tolérance pour le gap
          })
          
          if (cardsToRight.length === 0) {
            // Pas de carte à droite, prendre toute la largeur
            card.classList.remove('xl:col-span-2')
            card.classList.add('xl:col-span-3')
          } else {
            // Il y a une carte à droite, garder col-span-2
            card.classList.remove('xl:col-span-3')
            if (!card.classList.contains('xl:col-span-2')) {
              card.classList.add('xl:col-span-2')
            }
          }
        }
      })
    }, 100)
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

const hooks = {
  ...colocatedHooks,
  ThemeManager: ThemeManagerHook,
  ContextMenuNotification: ContextMenuNotificationHook,
  UISearch: UISearchHook,
  UICategory: UICategoryHook,
  BentoGrid: BentoGrid
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

