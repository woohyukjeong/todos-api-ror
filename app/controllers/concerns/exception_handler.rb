module ExceptionHandler
  extend ActiveSupport::Concern

  # 인증관련 에러 서브 클래스 정의
  class InvalidToken < StandardError; end
  class MissingToken < StandardError; end
  class AuthenticationError < StandardError; end

  included do
    rescue_from ActiveRecord::RecordNotFound do |e|
      err_response(e.message, :not_found)
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      err_response(e.message, :unprocessable_entity)
    end

    rescue_from ActionController::ParameterMissing do |e|
      err_response(e.message, :bad_request)
    end

    rescue_from ExceptionHandler::InvalidToken, with: :unauthorized_request
    rescue_from ExceptionHandler::MissingToken, with: :unauthorized_request
    rescue_from ExceptionHandler::AuthenticationError, with: :unauthorized_request
  end

  private

  # JSON Response - 401 Unauthorized
  def unauthorized_request(e)
    err_response(e.message, :unauthorized)
  end

  # JSON Error Response - general method
  def err_response(err, status)
    json_response({ message: err.message}, status)
  end
end