import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["image", "placeholder"]

  connect() {
    if (this.imageTarget.complete) {
      this.imageLoaded()
    }
  }

  imageLoaded() {
    this.element.classList.add("loaded")
  }

  imageError() {
    this.element.classList.add("error")
  }
}