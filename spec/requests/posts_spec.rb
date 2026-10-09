require "rails_helper"

RSpec.describe "Posts", type: :request do
  describe "POST /posts" do
    it "ログイン済みユーザーなら投稿を作成できる" do
      user = create(:user, email: "test@example.com")

      post login_path, params: {
        email: user.email,
        password: "password"
      }

      expect {
        post posts_path, params: {
          post: {
            title: "テストタイトル",
            body: "テスト本文"
          }
        }
      }.to change(Post, :count).by(1)

      expect(response).to redirect_to(post_path(Post.last))
    end

    it "未ログインなら投稿できない" do
      expect {
        post posts_path, params: {
          post: {
            title: "テストタイトル",
            body: "テスト本文"
          }
        }
      }.not_to change(Post, :count)

      expect(response).to redirect_to(login_path)
    end

    it "titleが空なら投稿できない" do
      user = create(:user, email: "test@example.com")

      post login_path, params: {
        email: user.email,
        password: "password"
      }

      expect {
        post posts_path, params: {
          post: {
            title: "",
            body: "テスト本文"
          }
        }
      }.not_to change(Post, :count)

      expect(response).to have_http_status(:unprocessable_content)
    end

    it "bodyが空なら投稿できない" do
      user = create(:user, email: "test@example.com")

      post login_path, params: {
        email: user.email,
        password: "password"
      }

      expect {
        post posts_path, params: {
          post: {
            title: "テストタイトル",
            body: ""
          }
        }
      }.not_to change(Post, :count)

      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "PATCH /posts/:id" do
    it "ログイン済みユーザーなら自分の投稿を更新できる" do
      user = create(:user, email: "test@example.com")

      post login_path, params: {
        email: user.email,
        password: "password"
      }

      post_record = create(
        :post,
        user: user,
        title: "変更前のタイトル",
        body: "変更前の本文"
      )

      patch post_path(post_record), params: {
        post: {
          title: "変更後のタイトル",
          body: "変更後の本文"
        }
      }

      expect(post_record.reload.title).to eq("変更後のタイトル")
      expect(post_record.reload.body).to eq("変更後の本文")
      expect(response).to redirect_to(post_path(post_record))
    end

    it "titleが空なら投稿を更新できない" do
      user = create(:user, email: "test@example.com")

      post login_path, params: {
        email: user.email,
        password: "password"
      }

      post_record = create(
        :post,
        user: user,
        title: "変更前のタイトル",
        body: "変更前の本文"
      )

      patch post_path(post_record), params: {
        post: {
          title: "",
          body: "変更後の本文"
        }
      }

      expect(post_record.reload.title).to eq("変更前のタイトル")
      expect(post_record.reload.body).to eq("変更前の本文")
      expect(response).to have_http_status(:unprocessable_content)
    end

    it "bodyが空なら投稿を更新できない" do
      user = create(:user, email: "test@example.com")

      post login_path, params: {
        email: user.email,
        password: "password"
      }

      post_record = create(
        :post,
        user: user,
        title: "変更前のタイトル",
        body: "変更前の本文"
      )

      patch post_path(post_record), params: {
        post: {
          title: "変更後のタイトル",
          body: ""
        }
      }

      expect(post_record.reload.title).to eq("変更前のタイトル")
      expect(post_record.reload.body).to eq("変更前の本文")
      expect(response).to have_http_status(:unprocessable_content)
    end

    it "他人の投稿は更新できない" do
      user = create(:user)
      another_user = create(:user)

      post login_path, params: {
        email: user.email,
        password: "password"
      }

      post_record = create(
        :post,
        user: another_user,
        title: "変更前のタイトル",
        body: "変更前の本文"
      )

      patch post_path(post_record), params: {
        post: {
          title: "変更後のタイトル",
          body: "変更後の本文"
        }
      }

      expect(post_record.reload.title).to eq("変更前のタイトル")
      expect(post_record.reload.body).to eq("変更前の本文")
      expect(response).to have_http_status(:not_found)
    end

    it "未ログインなら投稿を更新できない" do
      user = create(:user)
      post_record = create(
        :post,
        user: user,
        title: "変更前のタイトル",
        body: "変更前の本文"
      )

      patch post_path(post_record), params: {
        post: {
          title: "変更後のタイトル",
          body: "変更後の本文"
        }
      }

      expect(post_record.reload.title).to eq("変更前のタイトル")
      expect(post_record.reload.body).to eq("変更前の本文")
      expect(response).to redirect_to(login_path)
    end
  end

  describe "DELETE /posts/:id" do
    it "ログイン済みユーザーなら自分の投稿を削除できる" do
      user = create(:user, email: "test@example.com")

      post login_path, params: {
        email: user.email,
        password: "password"
      }

      post_record = create(
        :post,
        user: user,
        title: "削除するタイトル",
        body: "削除する本文"
      )

      expect {
        delete post_path(post_record)
      }.to change(Post, :count).by(-1)

      expect(response).to redirect_to(posts_path)
      expect(response).to have_http_status(:see_other)
    end

    it "未ログインなら投稿を削除できない" do
      user = create(:user)
      post_record = create(
        :post,
        user: user,
        title: "削除できないタイトル",
        body: "削除できない本文"
      )

      expect {
        delete post_path(post_record)
      }.not_to change(Post, :count)

      expect(response).to redirect_to(login_path)
    end

    it "他人の投稿は削除できない" do
      user = create(:user)
      another_user = create(:user)

      post login_path, params: {
        email: user.email,
        password: "password"
      }

      post_record = create(
        :post,
        user: another_user,
        title: "他人のタイトル",
        body: "他人の本文"
      )

      expect {
        delete post_path(post_record)
      }.not_to change(Post, :count)

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET /posts" do
    it "投稿一覧を表示できる" do
      user = create(:user)
      create(:post, user: user, title: "一覧テストのタイトル")

      post login_path, params: {
        email: user.email,
        password: "password"
      }

      get posts_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("一覧テストのタイトル")
    end
  end

  describe "GET /posts/:id" do
    it "投稿詳細を表示できる" do
      user = create(:user)
      post_record = create(
      :post,
      user: user,
      title: "詳細テストのタイトル",
      body: "詳細テストの本文"
      )

      post login_path, params: {
        email: user.email,
        password: "password"
      }

      get post_path(post_record)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("詳細テストのタイトル")
      expect(response.body).to include("詳細テストの本文")
    end
  end

  describe "GET /posts/search" do
    it "キーワードに一致する投稿を表示できる" do
      user = create(:user)
      create(:post, user: user, title: "Rubyの学習", body: "Railsを勉強中")
      create(:post, user: user, title: "料理の日記", body: "カレーを作った")

      post login_path, params: {
        email: user.email,
        password: "password"
      }

      get search_posts_path, params: { q: "Ruby" }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Rubyの学習")
      expect(response.body).not_to include("料理の日記")
    end

    it "本文に一致するキーワードでも検索できる" do
      user = create(:user)
      create(:post, user: user, title: "学習記録", body: "Railsを勉強中")
      create(:post, user: user, title: "料理の日記", body: "カレーを作った")

      post login_path, params: {
        email: user.email,
        password: "password"
      }

      get search_posts_path, params: { q: "Rails" }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("学習記録")
      expect(response.body).not_to include("料理の日記")
    end

    it "検索キーワードが空なら入力を促すメッセージを表示する" do
      user = create(:user)
      create(:post, user: user, title: "空検索のテスト")

      post login_path, params: {
        email: user.email,
        password: "password"
      }

      get search_posts_path, params: { q: "" }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("検索キーワードを入力してください。")
      expect(response.body).not_to include("空検索のテスト")
    end
  end
end
