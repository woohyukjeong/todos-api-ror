require 'rails_helper'

RSpec.describe 'Authentication', type: :request do
  # 유저 로그인 테스트 케이스
  describe 'POST /auth/login' do
    # 테스트용 유저 생성
    let!(:user) { create(:user) }
    # 로그인 요청이기 때문에 Authorization header는 제외
    let(:headers) { valid_headers.except('Authorization') }
    # 유효한 인증과 그렇지 않은 인증 데이터 세팅
    let(:valid_credentials) do
      {
        email: user.email,
        password: user.password
      }.to_json
    end
    let(:invalid_credentials) do
      {
        email: Faker::Internet.email,
        password: Faker::Internet.password
      }.to_json
    end

    # 요청이 유효한 경우 JWT를 리턴
    context 'When request is valid' do
      before { post '/auth/login', params: valid_credentials, headers: headers }

      it 'returns an authentication token' do
        expect(json['auth_token']).not_to be_nil
      end
    end

    # 요청이 유효하지 않은 경우 에러 메시지 리턴
    context 'When request is invalid' do
      before { post '/auth/login', params: invalid_credentials, headers: headers }

      it 'returns a failure message' do
        expect(json['message']).to match(/Invalid credentials/)
      end

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end
  end
end
