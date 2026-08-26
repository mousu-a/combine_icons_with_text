import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["uploadButton", "editControls", "dropZone"];

  enableEditMode() {
    this.editControlsTarget.disabled = false;
    this.uploadButtonTarget.textContent = "画像を変更";
    this.uploadButtonTarget.classList.add("is-secondary");
  }

  dragOver(e) {
    e.preventDefault();
    e.dataTransfer.dropEffect = "copy";
  }

  dragEnter(e) {
    e.preventDefault();
    this.dropZoneTarget.classList.add("is-dragging");
  }

  dragLeave(e) {
    if (e.relatedTarget && e.currentTarget.contains(e.relatedTarget)) return;

    this.dropZoneTarget.classList.remove("is-dragging");
  }

  drop() {
    this.dropZoneTarget.classList.remove("is-dragging");
  }
}
