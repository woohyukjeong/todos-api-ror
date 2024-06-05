class JsonWebToken
  # 암호화 및 복호화에 사용할 Secret 값
  HMAC_SECRET = Rails.application.secret_key_base

  # JWT 생성
  def self.encode(payload, exp = 1.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, HMAC_SECRET)
  end

  # JWT 복호화
  def self.decode(token)
    begin
      body = JWT.decode(token, HMAC_SECRET)[0]
      # body에 접근할 때 hash key에 대하여 문자열과 심볼 모두로 접근할 수 있도록 변환
      HashWithIndifferentAccess.new body
    rescue JWT::DecodeError => e
      raise ExceptionHandler::InvalidToken, e.message
    end
  end

end