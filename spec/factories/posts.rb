FactoryBot.define do
  factory :post do
    association :user
    title { "テストタイトル" }
    body { "テスト本文です。" }
  end
end
