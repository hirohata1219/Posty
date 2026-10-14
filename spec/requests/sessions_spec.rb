require "rails_helper"

RSpec.describe "Sessions", type: :request do
  let(:user) { create(:user) }
  let(:valid_login_params) do {
    email: user.email,
    password: "password"
  }
  end

  describe "POST /login" do
    it "正しいemailとpasswordならログインに成功する" do
      post login_path, params: valid_login_params

      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response).to have_http_status(:ok)
    end

    it "間違ったpasswordならログインに失敗する" do
      post login_path, params: valid_login_params.merge(password: "wrong_password")

      expect(response).to have_http_status(:unprocessable_content)
    end

    it "存在しないemailならログインに失敗する" do
      post login_path, params: valid_login_params.merge(email: "not_found@example.com")

      expect(response).to have_http_status(:unprocessable_content)
    end

    it "emailが空ならログインに失敗する" do
      post login_path, params: valid_login_params.merge(email: "")

      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "DELETE /logout" do
    before do
      post login_path, params: valid_login_params
    end

    it "ログアウトするとログイン画面にリダイレクトする" do
      delete logout_path

      expect(response).to redirect_to(login_path)
      expect(response).to have_http_status(:see_other)
    end

    it "ログアウト後は保護されたページにアクセスできない" do
      delete logout_path

      get profile_path

      expect(response).to redirect_to(login_path)
    end
  end
end
