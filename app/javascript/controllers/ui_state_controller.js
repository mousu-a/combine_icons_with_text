import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["instructionText", "uploadButton", "editControls"];

  change() {
    this.instructionTextTarget.textContent = "画像を選択しました";
    this.uploadButtonTarget.textContent = "画像を変更";
    this.uploadButtonTarget.classList.add("is-secondary");
    this.editControlsTarget.disabled = false;
    this.editControlsTarget.classList.remove("is-disabled-controls");
  }
}
