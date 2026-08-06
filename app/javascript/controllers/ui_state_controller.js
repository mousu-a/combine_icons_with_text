import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["instructionText", "uploadButton"];

  change() {
    this.instructionTextTarget.textContent = "アイコンを変更する場合はこちら";
    this.uploadButtonTarget.textContent = "アイコンを変更";

    this.uploadButtonTarget.classList.add("is-muted");
    this.instructionTextTarget.classList.add("is-muted");
  }
}
