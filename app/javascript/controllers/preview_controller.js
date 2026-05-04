import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["previewImage"];

  get previewImageUrl() {
    return this.previewImageTarget.src;
  }

  setup(event) {
    this.previewImageTarget.src = event.detail.originalImage.src;
    this.previewImageTarget.style.display = "inline";
  }

  render(event) {
    let url = URL.createObjectURL(event.detail.canvasBlob);
    this.previewImageTarget.src = url;
  }
}
