import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button"]

  connect() {
    this.element.addEventListener("show.bs.collapse", () => {
      this.buttonTarget.classList.remove("btn-dark")
      this.buttonTarget.classList.add("btn-outline-light")
    })

    this.element.addEventListener("hide.bs.collapse", () => {
      this.buttonTarget.classList.remove("btn-outline-light")
      this.buttonTarget.classList.add("btn-dark")
    })
  }
}