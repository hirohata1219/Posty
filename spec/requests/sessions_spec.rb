require "rails_helper"

RSpec.describe "Sessions", type: :request do
  describe "POST /login" do
    it "正しいemailとpasswordならログインに成功する" do
      user = create(:user, email: "test@example.com")
      post login_path, params: {
        email: user.email,
        password: "password"
      }
      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response).to have_http_status(:ok)
    end

    it "間違ったpasswordならログインに失敗する" do
      user = create(:user, email: "test@example.com")
      post login_path, params: {
        email: user.email,
        password: "wrong_password"
      }
      expect(response).to have_http_status(:unprocessable_content)
    end

    it "存在しないemailならログインに失敗する" do
      post login_path, params: {
        email: "not_found@example.com",
        password: "password"
      }
      expect(response).to have_http_status(:unprocessable_content)
    end

    it "emailが空ならログインに失敗する" do
      post login_path, params: {
        email: "",
        password: "password"
      }
      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "DELETE /logout" do
    it "ログアウトするとログイン画面にリダイレクトする" do
      user = create(:user)

      post login_path, params: {
        email: user.email,
        password: "password"
      }

      delete logout_path

      expect(response).to redirect_to(login_path)
      expect(response).to have_http_status(:see_other)
    end

    it "ログアウト後は保護されたページにアクセスできない" do
      user = create(:user)

      post login_path, params: {
        email: user.email,
        password: "password"
      }

      delete logout_path

      get profile_path

      expect(response).to redirect_to(login_path)
    end
  end
end