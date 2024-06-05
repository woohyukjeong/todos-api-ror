# 매API 요청의 Header에 포함된 Token 유효성을 검증하는 클래스
class AuthorizeApiRequest
  def initialize(headers = {})
    @headers = headers
  end

  # 유효한 user record를 리턴한다
  def call
    {
      user: user
    }
  end

  private

  attr_reader :headers

  def user
    # database에서 유저를 찾는다
    @user ||= User.find(decoded_auth_token[:user_id]) if decoded_auth_token
    # User가 존재하지 않을 경우 에러
  rescue ActiveRecord::RecordNotFound => e
    # 잘못된 토큰 정보
    raise(
      ExceptionHandler::InvalidToken,
      ("#{Message.invalid_token} #{e.message}")
    )
  end

  # JWT를 검증한다
  def decoded_auth_token
    # decoded_auth_token의 값이 없을 떄에만 decode된 값을 적용
    @decoded_auth_token ||= JsonWebToken.decode(http_auth_header)
  end

  # Request Header에서 토큰을 분리한다
  def http_auth_header
    if headers['Authorization'].present?
      return headers['Authorization'].split(' ').last
    end
    raise(ExceptionHandler::MissingToken, Message.missing_token)
  end
end
