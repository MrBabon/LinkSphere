import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="message-form"
export default class extends Controller {
  static targets = ["form", "content"]

  resetForm() {
    this.contentTarget.value = '' // Vide le champ de saisie du contenu
  }

  connect() {
    console.log("MessageFormController connected");
  }

  submitOnEnter(event) {
    if (event.key === "Enter" && !event.shiftKey) {
      event.preventDefault();
      this.formTarget.requestSubmit();
      this.resetForm()
    }
  }

  send(event) {
    event.preventDefault()
    this.formTarget.requestSubmit()
    this.resetForm() // Réinitialise aussi le formulaire lors de l'utilisation du bouton Send
  }
}
