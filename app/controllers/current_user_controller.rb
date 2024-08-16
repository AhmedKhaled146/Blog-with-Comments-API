class CurrentUserController < ApplicationController
  before_action :authenticate_user!

  def index
    user_data = UserSerializer.new(current_user, include: [:posts]).serializable_hash

    render json: {
      json: user_data,
      count: current_user.posts.count
    }, status: :ok
  end


end
