class AiController < ApplicationController
  def improve_post
    text = params[:text]

    if text.blank?
      return render json: {
        error: "文章を入力してください。"
      }, status: :unprocessable_entity
    end

    improved_text = OpenaiService.new.improve_text(text)

    render json: {
      text: improved_text
    }

  rescue StandardError => e
    Rails.logger.error("OpenAI error: #{e.class}: #{e.message}")
    render json: {
      error: "文章の改善に失敗しました。時間をおいて再度お試しください。"
    }, status: :service_unavailable
  end
end