
module ControllerSpecHelper
  # UserId로 JWT를 생성
  def token_generator(user_id)
    JsonWebToken.encode(user_id: user_id)
  end

  # UserId로 만료된 JWT를 생성
  def expired_token_generator(user_id)
    JsonWebToken.encode({ user_id: user_id }, (Time.now.to_i - 10))
  end

  # 유효한 헤더를 리턴
  def valid_headers
    {
      "Authorization" => token_generator(user.id),
      "Content-Type" => "application/json"
    }
  end

  # 유효하지 않은 헤더를 리턴
  def invalid_headers
    {
      "Authorization" => nil,
      "Content-Type" => "application/json"
    }
  end
end