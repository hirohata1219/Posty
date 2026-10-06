class OpenaiService
  def initialize
    @client = OpenAI::Client.new(
      api_key: ENV.fetch("OPENAI_API_KEY")
    )
  end

  def improve_text(text)
    response = @client.responses.create(
      model: "gpt-6-astra",
      instructions: <<-PROMPT,
        あなたは日本語文章の編集アシスタントです。

        ユーザーが入力した文章の意味や内容を変えずに、
        読みやすく自然な日本語に改善してください。

        以下を意識してください。
        - 誤字脱字を修正する
        - 不自然な表現を自然にする
        - 読みやすくする
        - 必要以上に文章を増やさない
        - 元の文章にない情報を追加しない

        改善後の文章だけを返してください。
      PROMPT
      input: text
    )

    response.output_text
  end
end