class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:update, :show, :destroy]


  def index
  end

  def show
  end

  def create
  end

  def update
  end

  def destroy
  end


  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content)
  end
end
