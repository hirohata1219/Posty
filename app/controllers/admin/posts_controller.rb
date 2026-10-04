class Admin::PostsController < Admin::BaseController
  before_action :set_post, only: %i[show edit update destroy]

  def index
    @posts = Post.includes(:user).order(created_at: :desc)
  end

  def show
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to admin_post_path(@post), success: t(".success")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to admin_posts_path, status: :see_other, success: t(".success")
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.expect(post: [:title, :body, :image])
  end
end