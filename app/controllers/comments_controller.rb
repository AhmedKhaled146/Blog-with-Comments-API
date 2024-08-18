class CommentsController < ApplicationController
  before_action :set_post
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_comment, only: [:show, :update, :destroy]
  before_action :authorize_comment_owner, only: [:update, :destroy]

  # Done
  def index
    @comments = @post.comments.all
    render json: @comments
  end

  # Done
  def show
    render json: @comment
  end

  # Done
  def create
    if @post.user_id == current_user.id
      render json: { error: "You cannot comment on your own post" }, status: :forbidden
      return
    end

    @comment = @post.comments.new(comment_params.merge(user_id: current_user.id))
    if @comment.save
      render json: @comment, status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def update
    if @comment.update(comment_params)
      render json: @comment
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @comment.destroy
      render json: {message: "deleted successfully"}
    else
      render json: @comment.errors.full_messages, status: :unprocessable_entity
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Post not found" }, status: :not_found
  end

  def set_comment
    @comment = @post.comments.find(params[:comment_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "comment not found" }, status: :not_found
  end

  def comment_params
    params.require(:comment).permit(:content)
  end

  def authorize_comment_owner
    unless @comment.user_id == current_user.id
      render json: { error: "You are not authorized to perform this action" }, status: :forbidden
    end
  end

end
