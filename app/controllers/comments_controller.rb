class CommentsController < ApplicationController
  before_action :set_post

  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to @post, success: t(".success")
    else
      @comments = @post.comments.includes(:user).order(created_at: :desc)
      render "posts/show", status: :unprocessable_entity
    end
  end

  def destroy
    @comment = current_user.comments.find(params[:id])
    @comment.destroy

    redirect_to @post, status: :see_other, success: t("defaults.flash_message.deleted", item: Comment.model_name.human)
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.expect(comment: [ :body ])
  end
end
