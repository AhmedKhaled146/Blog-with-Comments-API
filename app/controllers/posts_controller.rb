class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_post, only: [:update, :show, :destroy]
  before_action :authorize_post_owner, only: [:update, :destroy]


  def index
    @posts = Post.page(params[:page]).per(20)
    render json: {
      json: @posts, meta: pagination_meta(@posts),
      count: @posts.count
    }
  end

  def show
    render json: @post
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      render json: {
        post: @post,
        status: :created,
        message: "#{@post.title} post created successfully"
      }
    else
      render json: @post.errors.full_messages, status: :unprocessable_entity
    end
  end


  def update
    if @post.update(post_params)
      render json: @post
    else
      render json: @post.errors.full_messages, status: :unprocessable_entity
    end
  end


  def destroy
    if @post.destroy
      render json: {message: "deleted successfully"}
    else
      render json: @post.errors.full_messages, status: :unprocessable_entity
    end
  end


  private

  def pagination_meta(post)
    {
      current_page: post.current_page,
      next_page: post.next_page,
      prev_page: post.prev_page,
      total_pages: post.total_pages,
      total_count: post.total_count
    }
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content)
  end

  def authorize_post_owner
    unless @post.user_id == current_user.id
      render json: { error: "You are not authorized to perform this action" }, status: :forbidden
    end
  end
end
