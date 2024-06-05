require 'rails_helper'

RSpec.describe AuthenticateUser do
  # 테스트 유저 생성
  let(:user) { create(:user) }
  # 유효한 인증정보 생성
  subject(:valid_auth_obj) { described_class.new(user.email, user.password) }
  # 유효하지 않은 인증정보 생성
  subject(:invalid_auth_obj) { described_class.new('foo', 'bar') }

  # AuthenticateUser#call 서비스 클래스 테스트 케이스
  describe '#call' do
    # 유효한 요청에 대해서 토큰 정보를 리턴
    context 'when valid credentials' do
      it 'returns an auth token' do
        token = valid_auth_obj.call
        expect(token).not_to be_nil
      end
    end

    # 유효하지 않은 요청에 대해 AuthenticationError 발생
    context 'when invalid credentials' do
      it 'raises an authentication error' do
        expect { invalid_auth_obj.call }
          .to raise_error(
                ExceptionHandler::AuthenticationError,
                /Invalid credentials/
              )
      end
    end
  end
end
