require "rails_helper"

RSpec.describe "Posts", type: :request do
  let(:user) { create(:user) }
  let(:valid_post_attributes) do
    { title: "テストタイトル", body: "テスト本文" }
  end
  let(:original_post_attributes) do
    { title: "変更前のタイトル", body: "変更前の本文" }
  end
  let(:updated_post_attributes) do
    { title: "変更後のタイトル", body: "変更後の本文" }
  end

  describe "POST /posts" do
    context "ログイン済みの場合" do
      before do
        post login_path, params: {
          email: user.email,
          password: "password"
        }
      end

      it "投稿を作成できる" do
        expect {
          post posts_path, params: {
            post: valid_post_attributes
          }
        }.to change(Post, :count).by(1)

        expect(response).to redirect_to(post_path(Post.last))
      end

      it "titleが空なら投稿できない" do
        expect {
          post posts_path, params: {
            post: valid_post_attributes.merge(title: "")
          }
        }.not_to change(Post, :count)

        expect(response).to have_http_status(:unprocessable_content)
      end

      it "bodyが空なら投稿できない" do
        expect {
          post posts_path, params: {
            post: valid_post_attributes.merge(body: "")
          }
        }.not_to change(Post, :count)

        expect(response).to have_http_status(:unprocessable_content)
      end
    end

    context "未ログインの場合" do
      it "投稿できない" do
        expect {
          post posts_path, params: {
            post: valid_post_attributes
          }
        }.not_to change(Post, :count)

        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "PATCH /posts/:id" do
    context "ログイン済みの場合" do
      before do
        post login_path, params: {
          email: user.email,
          password: "password"
        }
      end

      it "自分の投稿を更新できる" do
        post_record = create(
          :post,
          user: user,
          **original_post_attributes
        )

        patch post_path(post_record), params: {
          post: updated_post_attributes
        }

        post_record.reload
        expect(post_record.title).to eq(updated_post_attributes[:title])
        expect(post_record.body).to eq(updated_post_attributes[:body])
        expect(response).to redirect_to(post_path(post_record))
      end

      it "titleが空なら投稿を更新できない" do
        post_record = create(
          :post,
          user: user,
          **original_post_attributes
        )

        patch post_path(post_record), params: {
          post: updated_post_attributes.merge(title: "")
        }

        post_record.reload
        expect(post_record.title).to eq(original_post_attributes[:title])
        expect(post_record.body).to eq(original_post_attributes[:body])
        expect(response).to have_http_status(:unprocessable_content)
      end

      it "bodyが空なら投稿を更新できない" do
        post_record = create(
          :post,
          user: user,
          **original_post_attributes
        )

        patch post_path(post_record), params: {
          post: updated_post_attributes.merge(body: "")
        }

        post_record.reload
        expect(post_record.title).to eq(original_post_attributes[:title])
        expect(post_record.body).to eq(original_post_attributes[:body])
        expect(response).to have_http_status(:unprocessable_content)
      end

      it "他人の投稿は更新できない" do
        another_user = create(:user)

        post_record = create(
          :post,
          user: another_user,
          **original_post_attributes
        )

        patch post_path(post_record), params: {
          post: updated_post_attributes
        }

        post_record.reload
        expect(post_record.title).to eq(original_post_attributes[:title])
        expect(post_record.body).to eq(original_post_attributes[:body])
        expect(response).to have_http_status(:not_found)
      end
    end

    context "未ログインの場合" do
      it "投稿を更新できない" do
        post_record = create(
          :post,
          user: user,
          **original_post_attributes
        )

        patch post_path(post_record), params: {
          post: updated_post_attributes
        }

        post_record.reload
        expect(post_record.title).to eq(original_post_attributes[:title])
        expect(post_record.body).to eq(original_post_attributes[:body])
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "DELETE /posts/:id" do
    context "ログイン済みの場合" do
      before do
        post login_path, params: {
          email: user.email,
          password: "password"
        }
      end

      it "自分の投稿を削除できる" do
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

      it "他人の投稿は削除できない" do
        another_user = create(:user)

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

    context "未ログインの場合" do
      it "投稿を削除できない" do
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
    end
  end

  describe "GET /posts" do
    context "ログイン済みの場合" do
      before do
        post login_path, params: {
          email: user.email,
          password: "password"
        }
      end

      it "投稿一覧を表示できる" do
        create(:post, user: user, title: "一覧テストのタイトル")

        get posts_path

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("一覧テストのタイトル")
      end
    end
  end

  describe "GET /posts/:id" do
    context "ログイン済みの場合" do
      before do
        post login_path, params: {
          email: user.email,
          password: "password"
        }
      end
      it "投稿詳細を表示できる" do
        post_record = create(
          :post,
          user: user,
          title: "詳細テストのタイトル",
          body: "詳細テストの本文"
        )

        get post_path(post_record)

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("詳細テストのタイトル")
        expect(response.body).to include("詳細テストの本文")
      end
    end
  end

  describe "GET /posts/search" do
    context "ログイン済みの場合" do
      before do
        post login_path, params: {
          email: user.email,
          password: "password"
        }
      end

      it "キーワードに一致する投稿を表示できる" do
        create(:post, user: user, title: "Rubyの学習", body: "Railsを勉強中")
        create(:post, user: user, title: "料理の日記", body: "カレーを作った")

        get search_posts_path, params: { q: "Ruby" }

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Rubyの学習")
        expect(response.body).not_to include("料理の日記")
      end

      it "本文に一致するキーワードでも検索できる" do
        create(:post, user: user, title: "学習記録", body: "Railsを勉強中")
        create(:post, user: user, title: "料理の日記", body: "カレーを作った")

        get search_posts_path, params: { q: "Rails" }

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("学習記録")
        expect(response.body).not_to include("料理の日記")
      end

      it "検索キーワードが空なら入力を促すメッセージを表示する" do
        create(:post, user: user, title: "空検索のテスト")

        get search_posts_path, params: { q: "" }

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("検索キーワードを入力してください。")
        expect(response.body).not_to include("空検索のテスト")
      end
    end
  end
end
