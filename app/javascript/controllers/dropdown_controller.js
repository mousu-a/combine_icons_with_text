import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["accountMenu"];

  toggle() {
    this.accountMenuTarget.classList.toggle("hidden");
  }
}
