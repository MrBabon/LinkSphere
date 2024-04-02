import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="participation"
export default class extends Controller {
  static targets = ["checkbox"];

  toggleValue() {
    const checkbox = this.checkboxTarget;
    if (checkbox) {
      checkbox.value = checkbox.checked ? "false" : "true";
    }  }
}
