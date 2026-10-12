require "rails_helper"

RSpec.describe "Users", type: :request do
  describe "POST /users" do
    it "ユーザー登録に成功する" do
      expect {
        post users_path, params: {
          user: {
            name: "テストユーザー",
            email: "test@example.com",
            password: "password",
            password_confirmation: "password"
          }
        }
      }.to change(User, :count).by(1)

      expect(response).to redirect_to(login_path)
    end

    it "nameが空なら登録失敗" do
      expect {
        post users_path, params: {
          user: {
            name: "",
            email: "test@example.com",
            password: "password",
            password_confirmation: "password"
          }
        }
      }.not_to change(User, :count)
      expect(response).to have_http_status(:unprocessable_content)
    end

    it "emailが空ならユーザー登録に失敗する" do
      expect {
        post users_path, params: {
          user: {
            name: "テストユーザー",
            email: "",
            password: "password",
            password_confirmation: "password"
          }
        }
      }.not_to change(User, :count)
      expect(response).to have_http_status(:unprocessable_content)
    end

    it "emailの形式が不正ならユーザー登録に失敗する" do
      expect {
        post users_path, params: {
          user: {
            name: "テストユーザー",
            email: "invalid-email",
            password: "password",
            password_confirmation: "password"
          }
        }
      }.not_to change(User, :count)
      expect(response).to have_http_status(:unprocessable_content)
    end

    it "登録済みのemailではユーザー登録に失敗する" do
      create(:user, email: "test@example.com")
      expect {
        post users_path, params: {
          user: {
            name: "別のユーザー",
            email: "test@example.com",
            password: "password",
            password_confirmation: "password"
          }
        }
      }.not_to change(User, :count)
      expect(response).to have_http_status(:unprocessable_content)
    end

    it "passwordが3文字未満ならユーザー登録に失敗する" do
      expect {
        post users_path, params: {
          user: {
            name: "テストユーザー",
            email: "test@example.com",
            password: "ab",
            password_confirmation: "ab"
          }
        }
      }.not_to change(User, :count)
      expect(response).to have_http_status(:unprocessable_content)
    end

    it "ユーザー登録に成功するとウェルカムメールを送信する" do
      expect {
        post users_path, params: {
          user: {
            name: "テストユーザー",
            email: "test@example.com",
            password: "password",
            password_confirmation: "password"
          }
        }
      }.to change(ActionMailer::Base.deliveries, :size).by(1)
      expect(response).to redirect_to(login_path)
      mail = ActionMailer::Base.deliveries.last
      expect(mail.to).to include("test@example.com")
    end
  end
end
