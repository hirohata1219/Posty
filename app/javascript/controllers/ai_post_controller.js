import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["body", "button", "status"]

  async improve() {
    const text = this.bodyTarget.value.trim()

    if (!text) {
      alert("文章を入力してください。")
      return
    }

    this.buttonTarget.disabled = true
    this.statusTarget.textContent = "AIが文章を改善しています..."

    try {
      const response = await fetch("/ai/improve_post", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document
            .querySelector('meta[name="csrf-token"]')
            .content
        },
        body: JSON.stringify({
          text: text
        })
      })

      const data = await response.json()

      if (!response.ok) {
        throw new Error(data.error || "AI処理に失敗しました。")
      }

      this.bodyTarget.value = data.text
      this.statusTarget.textContent = "文章を改善しました。"
    } catch (error) {
      console.error(error)
      this.statusTarget.textContent = "AI処理に失敗しました。"
      alert(error.message)
    } finally {
      this.buttonTarget.disabled = false
    }
  }
}