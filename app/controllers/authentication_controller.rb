class AuthenticationController < ApplicationController
  # User의 인증정보를 검증하고 JWT를 리턴하는 메서드
  def authenticate
    auth_token = AuthenticateUser.new(auth_params[:email], auth_params[:password]).call
    json_response(auth_token: auth_token, status: :ok)
  end

  private

  def auth_params
    params.permit(:email, :password)
  end
end
