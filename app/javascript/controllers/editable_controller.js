import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="editable"
export default class extends Controller {
  static targets = ["name", "form", "input"]

  connect() {
    if (this.hasFormTarget) {
      this.formTarget.addEventListener('submit', this.updateName);
    }
  }

  edit() {
    this.nameTarget.classList.add('d-none');
    this.formTarget.classList.remove('d-none');
    this.formTarget.addEventListener('submit', this.updateName);
    this.inputTarget.focus();
    this.inputTarget.value = this.outputName;
  }

  updateName(event) {
    const [data, status, xhr] = event.detail;
    this.nameTarget.textContent = xhr.response.name;
    this.nameTarget.classList.remove('d-none');
    this.formTarget.classList.add('d-none');
  }

  blur(event) {
    this.formTarget.classList.add('d-none'); 
    this.nameTarget.classList.remove('d-none'); 
    this.nameTarget.textContent = event.target.value || this.outputName;
    this.formTarget.removeEventListener('submit', this.updateName);
  }
}
