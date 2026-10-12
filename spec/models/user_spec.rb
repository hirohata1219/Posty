require "rails_helper"

RSpec.describe User, type: :model do
  describe "バリデーション" do
    it "nameがあれば有効" do
      user = build(:user)
      expect(user).to be_valid
    end

    it "nameがなければ無効" do
      user = build(:user, name: nil)
      expect(user).to be_invalid
    end

    it "emailがなければ無効" do
      user = build(:user, email: nil)
      expect(user).to be_invalid
    end

    it "emailが重複していたら無効" do
      create(:user, email: "test@example.com")
      user = build(:user, email: "test@example.com")
      expect(user).to be_invalid
    end

    it "emailの形式が不正なら無効" do
      user = build(:user, email: "invalid-email")
      expect(user).to be_invalid
    end

    it "passwordが3文字未満なら無効" do
      user = build(:user, password: "ab")
      expect(user).to be_invalid
    end

    it "passwordとpassword_confirmationが一致しなければ無効" do
      user = build(
        :user,
        password: "password",
        password_confirmation: "different"
        )
        expect(user).to be_invalid
    end

    it "bioが200文字以内なら有効" do
      user = build(:user, bio: "a" * 200)
      expect(user).to be_valid
    end

    it "bioが201文字以上なら無効" do
      user = build(:user, bio: "a" * 201)
      expect(user).to be_invalid
    end
  end

  describe "アソシエーション" do
    it { is_expected.to have_many(:posts) }
    it { is_expected.to have_many(:comments) }
    it { is_expected.to have_many(:likes) }
  end
end
