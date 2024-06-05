require 'rails_helper'

RSpec.describe User, type: :model do

  # User Model에 대한 테스트케이스

  # 관계 테스트 -> Todo Model과 1:m 관계
  it { should have_many(:todos) }

  # 필드 유효성 검증 테스트
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password_digest) }
end
