require 'rails_helper'

RSpec.describe AuthorizeApiRequest do
  # 테스트 유저 생성
  let(:user) { create(:user) }
  # 인증 토큰 헤더에 추가
  let(:header) { { 'Authorization' => token_generator(user.id) } }
  # 유효하지 않는 인증 요청
  subject(:invalid_request_obj) { described_class.new({}) }
  # 유효한 인증 요청
  subject(:request_obj) { described_class.new(header) }

  # AuthorizeApiRequest#call 테스트케이스
  describe '#call' do
    # 유효한 API 요청을 call 했을 때
    context 'when valid request' do
      it 'returns user object' do
        result = request_obj.call
        expect(result[:user]).to eq(user)
      end
    end

    # 유효하지 않는 요청을 call 했을 때
    context 'when invalid request' do
      context 'when missing token' do
        it 'raises a MissingToken error' do
          expect { invalid_request_obj.call }
            .to raise_error(ExceptionHandler::MissingToken, 'Missing token')
        end
      end

      context 'when invalid token' do
        subject(:invalid_request_obj) do
          # 존재하지 않는 user_id로 토큰을 생성해서 요청 헤더에 포함시킨 경우
          described_class.new('Authorization' => token_generator(5))
        end

        it 'raises an InvalidToken error' do
          expect { invalid_request_obj.call }
            .to raise_error(ExceptionHandler::InvalidToken, /Invalid token/)
        end
      end

      context 'when token is expired' do
        # 토큰 만료시간이 지났을 경우
        let(:header) { { 'Authorization' => expired_token_generator(user.id) } }
        subject(:request_obj) { described_class.new(header) }

        it 'raises ExceptionHandler::ExpiredSignature error' do
          expect { request_obj.call }
            .to raise_error(
                  ExceptionHandler::InvalidToken,
                  /Signature has expired/
                )
        end
      end

      context 'fake token' do
        # 잘못된 형식의 토큰을 포함시킨 경우
        let(:header) { { 'Authorization' => 'foobar' } }
        subject(:invalid_request_obj) { described_class.new(header) }

        it 'handles JWT::DecodeError' do
          expect { invalid_request_obj.call }
            .to raise_error(
                  ExceptionHandler::InvalidToken,
                  /Not enough or too many segments/
                )
        end
      end
    end
  end
end
