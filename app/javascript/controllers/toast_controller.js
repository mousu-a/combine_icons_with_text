import { Controller } from "@hotwired/stimulus";

const DEFAULT_DELAY_MS = 3000;

export default class extends Controller {
  static targets = ["toast", "toastMessage"];

  show(event) {
    const { success, message } = event.detail;
    const failure = !success;
    let delay = DEFAULT_DELAY_MS;

    this.toastMessageTarget.textContent = message;
    this.toastTarget.classList.toggle("flash-message--notice", success);
    this.toastTarget.classList.toggle("flash-message--alert", failure);
    if (failure) delay = DEFAULT_DELAY_MS + 2000;
    this.toastTarget.classList.remove("hidden");

    clearTimeout(this.timeout);
    this.timeout = setTimeout(() => {
      this.toastTarget.classList.add("hidden");
    }, delay);
  }

  disconnect() {
    clearTimeout(this.timeout);
  }
}
