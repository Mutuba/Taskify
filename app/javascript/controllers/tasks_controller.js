import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="tasks"
export default class extends Controller {
  connect() {
    console.log(this.element);
  }
}
