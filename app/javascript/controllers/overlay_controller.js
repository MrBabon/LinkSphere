import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="overlay"
export default class extends Controller {
  static targets = ["overlay", "modal"];

  toggle() {
    this.overlayTarget.classList.remove("d-none");
    this.overlayTarget.classList.add("d-flex");
    this.modalTarget.classList.remove("d-none");
    this.modalTarget.classList.add("d-grid");
  }

  closeModal() {
    this.overlayTarget.classList.add("d-none");
    this.overlayTarget.classList.remove("d-flex");
    this.modalTarget.classList.remove("d-grid");
    this.modalTarget.classList.add("d-none");
  }

  closeOnCodeInput() {
    // Ajoutez ici la logique pour valider le code d'inscription
    // et fermer l'overlay si le code est correct.
  }
}
