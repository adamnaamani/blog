import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    window.onbeforeunload = function(){
      return true
    }
  }

  disconnect() {
    window.onbeforeunload = null
  }
}