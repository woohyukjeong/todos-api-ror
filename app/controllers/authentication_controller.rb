class AuthenticationController < ApplicationController
  skip_before_action :authorize_request, only: :authenticate
  # User의 인증정보를 검증하고 JWT를 리턴하는 메서드
  def authenticate
    auth_token = AuthenticateUser.new(auth_params[:email], auth_params[:password]).call
    json_response(auth_token: auth_token, status: :ok)
  end

  private

  def auth_params
    permitted_params(required=[:email, :password], optional=[])
    # params.permit(:email, :password)
  end
end
