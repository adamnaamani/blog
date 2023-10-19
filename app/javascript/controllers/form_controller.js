import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "title", "content" ]
  static values = {
    scope: String,
    url: String,
  }

  connect() {
    this.token = document.querySelector("meta[name='csrf-token']").content
    this.element.classList.remove("hidden")
  }

  save() {
    clearTimeout(this.timeout)

    this.timeout = setTimeout(() => {
      fetch(this.urlValue, {
        method: 'POST',
        headers: {
          'X-CSRF-Token': this.token,
          'Content-Type': 'application/json'
        },
        credentials: 'same-origin',
        body: JSON.stringify({
          [this.scopeValue]: {
            title: this.titleTarget.value,
            content: this.contentTarget.value,
          },
        })
      }).then(response => response.text())
      .then(html => Turbo.renderStreamMessage(html))
    }, 200)
  }
}
