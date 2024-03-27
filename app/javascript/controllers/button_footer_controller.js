import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="button-footer"
export default class extends Controller {
  static targets = ["icon"];

  connect() {
    this.updateIcons();
    // Écouter les événements Turbo Drive pour mettre à jour les icônes après chaque navigation.
    document.addEventListener("turbo:load", this.updateIcons)
  }

  disconnect() {
    document.removeEventListener("turbo:load", this.updateIcons)
  }

  updateIcons = () => {
    const currentURL = window.location.href;
    this.iconTargets.forEach((icon) => {
      const linkURL = icon.parentElement.href;
      if (linkURL === currentURL) {
        icon.classList.remove("text-charcoal");
        icon.classList.add("text-primary");
      } else {
        icon.classList.add("text-charcoal");
        icon.classList.remove("text-primary");
      }
    });
  }
}
