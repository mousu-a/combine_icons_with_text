import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["previewImage", "previewImageFrame"];

  get previewImageUrl() {
    return this.previewImageTarget.src;
  }

  setup(event) {
    const previewImage = this.previewImageTarget;
    previewImage.src = event.detail.originalImage.src;

    const previewImageFrame =
      this.previewImageFrameTarget.getBoundingClientRect();
    previewImage.width = previewImageFrame.width - 20;
    previewImage.height = previewImageFrame.height - 20;

    previewImage.style.display = "inline";
  }

  render(event) {
    let url = URL.createObjectURL(event.detail.canvasBlob);
    this.previewImageTarget.src = url;
  }
}
