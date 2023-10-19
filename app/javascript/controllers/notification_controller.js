import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  connect() {
    this.handle()
  }

  handle() {
    setTimeout(() => {
      this.element.classList.add("opacity-0")
    }, 3000)
    setTimeout(() => {
      this.element.classList.add("hidden")
    }, 3300)
  }
}
