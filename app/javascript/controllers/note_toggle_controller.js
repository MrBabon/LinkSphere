import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="note-toggle"
export default class extends Controller {
  static targets = ["container", "form"]

  connect() {
    this.formTarget.classList.add("d-none"); // Cache le formulaire au chargement de la page
    this.containerTarget.classList.add("translate-y-full");

    this.isOpen = false;
  }

  toggle() {
    if (this.isOpen) {
      // Commencer l'animation de fermeture
      this.containerTarget.classList.replace("translate-y-20", "translate-y-full");

      // Attendre que l'animation soit terminée pour cacher complètement le formulaire
      setTimeout(() => {
        this.formTarget.classList.add("d-none");
      }, 300); // Correspond à la durée de l'animation

    } else {
      // Rendre le formulaire visible pour l'animation
      this.formTarget.classList.remove("d-none");

      // Assurer un délai pour permettre la transition CSS
      setTimeout(() => {
        this.containerTarget.classList.replace("translate-y-full", "translate-y-20");
      }, 10); // Un petit délai pour que la transition soit appliquée correctement

    }

    this.isOpen = !this.isOpen;
  }
}
