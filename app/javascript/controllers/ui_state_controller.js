import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["uploadButton", "editControls"];

  change() {
    this.uploadButtonTarget.textContent = "画像を変更";
    this.uploadButtonTarget.classList.add("is-secondary");
    this.editControlsTarget.disabled = false;
  }
}
