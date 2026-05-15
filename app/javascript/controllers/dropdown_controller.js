import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["avatarIcon", "logoutButton"];

  toggleLogoutButton() {
    this.logoutButtonTarget.classList.toggle("is-hidden");
  }
}
