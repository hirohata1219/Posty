import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["password", "passwordConfirmation"]

  generate() {
    const characters =
      "ABCDEFGHIJKLMNOPQRSTUVWXYZ" +
      "abcdefghijklmnopqrstuvwxyz" +
      "0123456789" +
      "!@#$%^&*"

    const length = 12
    const randomValues = new Uint32Array(length)

    crypto.getRandomValues(randomValues)

    let password = ""

    for (let i = 0; i < length; i++) {
      password += characters[randomValues[i] % characters.length]
    }

    this.passwordTarget.value = password
    this.passwordConfirmationTarget.value = password
  }

    // パスワードを表示・非表示
  togglePassword() {
    if (this.passwordTarget.type === "password") {
      this.passwordTarget.type = "text"
    } else {
      this.passwordTarget.type = "password"
    }
  }

  togglePasswordConfirmation() {
    if (this.passwordConfirmationTarget.type === "password") {
      this.passwordConfirmationTarget.type = "text"
    } else {
      this.passwordConfirmationTarget.type = "password"
    }
  }
}