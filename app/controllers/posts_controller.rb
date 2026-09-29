class PostsController < ApplicationController
  before_action :set_post, only: %i[edit update destroy]
  def index
    @pagy, @posts = pagy(:offset, Post.includes(:user).order(created_at: :desc), limit: 10)
  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to @post, success: t("defaults.flash_message.created", item: Post.model_name.human)
    else
      flash.now[:danger] = t("defaults.flash_message.not_created", item: Post.model_name.human)
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @post = Post.includes(:user).find(params[:id])
    @comment = Comment.new
    @comments = @post.comments.includes(:user).order(created_at: :desc)
    @liked = logged_in? && @post.likes.exists?(user: current_user)
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to @post, success: t("defaults.flash_message.updated", item: Post.model_name.human)
    else
      flash.now[:danger] = t("defaults.flash_message.not_updated", item: Post.model_name.human)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, status: :see_other, success: t("defaults.flash_message.deleted", item: Post.model_name.human)
  end

  private

  def post_params
    params.expect(post: [ :title, :body ])
  end

  def set_post
    @post = current_user.posts.find(params[:id])
  end
end
