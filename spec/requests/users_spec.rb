require "rails_helper"

RSpec.describe "Users", type: :request do
  let(:valid_user_attributes) do {
    name: "テストユーザー",
    email: "test@example.com",
    password: "password",
    password_confirmation: "password"
  }
  end

  describe "POST /users" do
    it "ユーザー登録に成功する" do
      expect {
        post users_path, params: {
          user: valid_user_attributes
        }
      }.to change(User, :count).by(1)

      expect(response).to redirect_to(login_path)
    end

    it "nameが空なら登録失敗" do
      expect {
        post users_path, params: {
          user: valid_user_attributes.merge(name: "")
        }
      }.not_to change(User, :count)
      expect(response).to have_http_status(:unprocessable_content)
    end

    it "emailが空ならユーザー登録に失敗する" do
      expect {
        post users_path, params: {
          user: valid_user_attributes.merge(email: "")
        }
      }.not_to change(User, :count)
      expect(response).to have_http_status(:unprocessable_content)
    end

    it "emailの形式が不正ならユーザー登録に失敗する" do
      expect {
        post users_path, params: {
          user: valid_user_attributes.merge(email: "invalid-email")
        }
      }.not_to change(User, :count)
      expect(response).to have_http_status(:unprocessable_content)
    end

    it "登録済みのemailではユーザー登録に失敗する" do
      create(:user, email: valid_user_attributes[:email])

      expect {
        post users_path, params: {
          user: valid_user_attributes.merge(name: "別のユーザー")
        }
      }.not_to change(User, :count)
      expect(response).to have_http_status(:unprocessable_content)
    end

    it "passwordが3文字未満ならユーザー登録に失敗する" do
      expect {
        post users_path, params: {
          user: valid_user_attributes.merge(password: "ab", password_confirmation: "ab")
        }
      }.not_to change(User, :count)
      expect(response).to have_http_status(:unprocessable_content)
    end

    it "ユーザー登録に成功するとウェルカムメールを送信する" do
      expect {
        post users_path, params: {
          user: valid_user_attributes
        }
      }.to change(ActionMailer::Base.deliveries, :size).by(1)
      expect(response).to redirect_to(login_path)
      mail = ActionMailer::Base.deliveries.last
      expect(mail.to).to include("test@example.com")
    end
  end
end
