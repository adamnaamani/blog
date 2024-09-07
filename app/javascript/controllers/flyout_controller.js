import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = [ "menu", "links" ]

  toggle(event) {
    event.preventDefault()
    event.stopPropagation()

    if (this.menuTarget.classList.contains("opacity-0")) {
      this.show(event)
    } else {
      this.hide(event)
    }
  }

  show(event) {
    event.stopPropagation()

    if (this.menuTarget.classList.contains("opacity-0")) {
      this.menuTarget.classList.add("opacity-100", "translate-y-0", "transition", "ease-out" ,"duration-200")
      this.menuTarget.classList.remove("opacity-0", "translate-y-1", "transition", "ease-in" ,"duration-150")
      this.linksTarget.classList.remove("hidden")
    }
  }

  hide(event) {
    event.stopPropagation()

    if (this.menuTarget.classList.contains("opacity-100")) {
      this.menuTarget.classList.add("opacity-0", "translate-y-1", "transition", "ease-in" ,"duration-150")
      this.menuTarget.classList.remove("opacity-100", "translate-y-0", "transition", "ease-out" ,"duration-200")
      setTimeout(() => {
        this.linksTarget.classList.add("hidden")
      }, 150)
    }
  }

  background(e) {
    if (e.target.dataset.layer === "background") {
      this.close(e)
    }
  }

  escape(e) {
    if (e.code == "Escape") {
      this.close(e)
    }
  }
}
