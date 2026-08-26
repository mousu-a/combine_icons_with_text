import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["previewImage", "previewImageFrame", "placeholder"];

  get previewImageUrl() {
    return this.previewImageTarget.src;
  }

  setup(event) {
    const previewImage = this.previewImageTarget;
    previewImage.src = event.detail.originalImage.src;

    const previewImageFrame =
      this.previewImageFrameTarget.getBoundingClientRect();
    const padding = 20;
    previewImage.width = previewImageFrame.width - padding;
    previewImage.height = previewImageFrame.height - padding;

    previewImage.style.display = "inline";
    this.placeholderTarget.classList.add("hidden");
  }

  render(event) {
    if (this.renderedImageUrl) URL.revokeObjectURL(this.renderedImageUrl);

    this.renderedImageUrl = URL.createObjectURL(event.detail.canvasBlob);
    this.previewImageTarget.src = this.renderedImageUrl;
  }

  disconnect() {
    if (!this.renderedImageUrl) return;

    URL.revokeObjectURL(this.renderedImageUrl);
    this.renderedImageUrl = null;
  }
}
