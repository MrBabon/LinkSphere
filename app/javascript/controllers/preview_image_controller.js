import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
  }

  previewImage(event) {
    const input = event.target;
    const previewContainer = document.getElementById("image-preview-container");
    const userAvatar = document.getElementById("user-avatar");

    const previewImage = document.createElement("img");
    previewImage.classList.add("rounded-circle", "img-avatar", "w-24", "h-24", "shadow-sm");

    if (input.files && input.files[0]) {
      const reader = new FileReader();

      reader.onload = function (e) {
        userAvatar.src = e.target.result;
        previewContainer.innerHTML = "";
        
      };

      reader.readAsDataURL(input.files[0]);
    }
  }

  previewBanner(event) {
    const input = event.target;
    const previewBanner = document.getElementById("image-preview-banner");
    const userAvatar = document.getElementById("banner");

    const previewImage = document.createElement("img");
    previewImage.classList.add("rounded-circle", "img-avatar", "w-24", "h-24", "shadow-sm");

    if (input.files && input.files[0]) {
      const reader = new FileReader();

      reader.onload = function (e) {
        userAvatar.src = e.target.result;
        previewBanner.innerHTML = "";
        
      };

      reader.readAsDataURL(input.files[0]);
    }
  }
}
