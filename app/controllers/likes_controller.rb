class LikesController < ApplicationController
  before_action :set_post

  def create
    @like = @post.likes.build(user: current_user)
    if @like.save
      redirect_to @post, success: t(".success")
    else
      redirect_to @post, danger: t(".failure")
    end
  end

  def destroy
    @like = @post.likes.find_by(user: current_user)
    if @like
      @like.destroy
      redirect_to @post, success: t(".success")
    else
      redirect_to @post
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end
end
