import "@hotwired/turbo-rails"
import "@rails/actiontext"
import "trix"
import "controllers"
import { HighlightJS } from "highlight.js"

document.addEventListener("turbo:load", () => {
  document.querySelectorAll("pre").forEach((block) => {
    block.classList.remove("language-php")
    block.classList.add("language-ruby")
    HighlightJS.highlightElement(block)
  })
})
