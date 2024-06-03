class User < ApplicationRecord
  # 비밀번호 암호화
  has_secure_password

  # 관계정의
  has_many :todos, foreign_key: :created_by

  # 유효성 검증
  validates_presence_of :name, :email, :password_digest
end
