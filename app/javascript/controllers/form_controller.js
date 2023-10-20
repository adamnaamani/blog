import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "title", "content", "description", "count" ]
  static values = {
    scope: String,
    url: String,
  }

  connect() {
    this.token = document.querySelector("meta[name='csrf-token']").content
    this.toolbar = document.querySelector('trix-toolbar')
    this.element.classList.remove("hidden")

    if (this.toolbar) {
      this.toolbar.classList.add('sticky', 'top-0')
    }
    if (this.hasCountTarget) {
      this.count()
    }
  }

  count() {
    this.countTarget.innerHTML = `${this.descriptionTarget.value.length} characters`
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
