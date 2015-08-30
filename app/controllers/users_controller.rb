class UsersController < ApplicationController

  skip_before_action :verify_authenticity_token

  def index
    result = {}
    result[:status] = '0'
    result[:message] = 'User list'
    result[:users] = User.pluck(:name, :email)
    render json: result
  end

  def create

    result = {}
    if User.find_or_create_by! user_params
      result[:status] = '0'
      result[:message] = 'User successfully added'
    else
      result[:status] = '1'
      result[:message] = 'Something went wrong could not add user.'
    end

    render json: result
  end

  private

  def user_params
    params.permit(:gcm_id, :email, :name)
  end
end
