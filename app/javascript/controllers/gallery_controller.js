import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["image", "modal", "modalImage", "close", "prev", "next", "overlay"]
  static values = {
    currentIndex: Number
  }

  connect() {
    this.currentIndexValue = 0
    this.images = this.imageTargets
  }

  open(event) {
    event.preventDefault()
    const clickedImage = event.currentTarget
    this.currentIndexValue = this.imageTargets.indexOf(clickedImage)
    this.showImage()
    this.modalTarget.classList.remove("opacity-0", "pointer-events-none")
    this.overlayTarget.classList.add("bg-opacity-90")
    document.body.style.overflow = "hidden"
  }

  close() {
    this.modalTarget.classList.add("opacity-0", "pointer-events-none")
    this.overlayTarget.classList.remove("bg-opacity-90")
    document.body.style.overflow = "auto"
  }

  showImage() {
    const imageContainer = this.images[this.currentIndexValue]
    const image = imageContainer.querySelector("img")
    this.modalImageTarget.src = image.src
    this.updateNavigationButtons()
  }

  next() {
    this.currentIndexValue = (this.currentIndexValue + 1) % this.images.length
    this.showImage()
  }

  prev() {
    this.currentIndexValue = (this.currentIndexValue - 1 + this.images.length) % this.images.length
    this.showImage()
  }

  updateNavigationButtons() {
    this.prevTarget.classList.remove("opacity-50")
    this.nextTarget.classList.remove("opacity-50")
  }

  keydown(event) {
    if (this.modalTarget.classList.contains("opacity-0")) return

    switch (event.key) {
      case "Escape":
        this.close()
        break
      case "ArrowLeft":
        this.prev()
        break
      case "ArrowRight":
        this.next()
        break
      default:
        break
    }
  }
}