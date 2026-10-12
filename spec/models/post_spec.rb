require "rails_helper"

RSpec.describe Post, type: :model do
  describe "バリデーション" do
    it "titleとbodyがあれば有効" do
      post = build(:post)
      expect(post).to be_valid
    end

    it "titleがなければ無効" do
      post = build(:post, title: "")
      expect(post).to be_invalid
    end

    it "bodyがなければ無効" do
      post = build(:post, body: "")
      expect(post).to be_invalid
    end
  end

  describe "アソシエーション" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:comments) }
    it { is_expected.to have_many(:likes) }
  end

  describe "検索" do
    it "titleにキーワードが含まれる投稿を取得する" do
      matching_post = create(:post, title: "Railsの勉強")
      create(:post, title: "Rubyの勉強")

      result = Post.search_by_keyword("Rails")

      expect(result).to include(matching_post)
      expect(result.size).to eq(1)
    end

    it "bodyにキーワードが含まれる投稿を取得する" do
      matching_post = create(:post, body: "RSpecを勉強する")
      create(:post, body: "SQLを勉強する")

      result = Post.search_by_keyword("RSpec")

      expect(result).to include(matching_post)
      expect(result.size).to eq(1)
    end

    it "空のキーワードなら全投稿を取得する" do
      create_list(:post, 2)

      expect(Post.search_by_keyword("")).to match_array(Post.all)
    end

    it "複数キーワードの両方を含む投稿を取得する" do
      matching_post = create(:post, title: "Rails", body: "RSpecのテスト")
      create(:post, title: "Rails", body: "SQLの勉強")

      result = Post.search_by_keyword("Rails RSpec")

      expect(result).to include(matching_post)
      expect(result.size).to eq(1)
    end
  end
end
