class AuthController < ApplicationController
  skip_before_action :authorized, only: [:signup, :login]

  def signup
    user = User.new(signup_params)
    if user.save
      render json: { token: encode_token(user_id: user.id) }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      render json: { token: encode_token(user_id: user.id) }, status: :ok
    else
      render json: { error: 'Invalid credentials' }, status: :unauthorized
    end
  end

  private

  def signup_params
    params.permit(:name, :email, :password, :password_confirmation, :image)
  end

  def encode_token(payload)
    JWT.encode(payload, Rails.application.secrets.secret_key_base)
  end
end
