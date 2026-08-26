import { Controller } from "@hotwired/stimulus";

const DEFAULT_DELAY_MS = 3000;

export default class extends Controller {
  connect() {
    this.timeout = setTimeout(() => {
      this.element.remove();
    }, DEFAULT_DELAY_MS);
  }

  disconnect() {
    clearTimeout(this.timeout);
  }
}
