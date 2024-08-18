class RepliesController < ApplicationController
  before_action :set_comment
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_reply, only: [:show, :update, :destroy]
  before_action :authorize_reply_owner, only: [:update, :destroy]

  def index
    @replies = @comment.replies.all
    render json: @replies
  end

  def show
    render json: @reply
  end

  def create
    @reply = @comment.replies.new(reply_params.merge(user_id: current_user.id))
    if @reply.save
      render json: @reply, status: :created
    else
      render json: @reply.errors, status: :unprocessable_entity
    end
  end

  def update
    if @reply.update(reply_params)
      render json: @reply
    else
      render json: @reply.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @reply.destroy
      render json: { message: "Reply deleted successfully" }
    else
      render json: @reply.errors.full_messages, status: :unprocessable_entity
    end
  end

  private

  def set_comment
    @comment = Comment.find(params[:comment_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Comment not found" }, status: :not_found
  end

  def set_reply
    @reply = @comment.replies.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Reply not found" }, status: :not_found
  end

  def reply_params
    params.require(:reply).permit(:content)
  end

  def authorize_reply_owner
    unless @reply.user_id == current_user.id
      render json: { error: "You are not authorized to perform this action" }, status: :forbidden
    end
  end
end
