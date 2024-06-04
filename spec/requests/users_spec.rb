require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  # DB에 저장하지 않고 user 객체를 생성
  let(:user) { build(:user) }
  let(:headers) { valid_headers.except('Authorization') }
  let(:valid_attributes) do
    # FactoryBot으로 생성된 User 정보를 Hash 형태로 리턴
    attributes_for(:user)
  end

  # 유저 회원가입 테스트 케이스
  describe 'POST /signup' do
    # 유저 생성시 요청 정보가 유효할 때
    context 'when valid request' do
      before { post '/signup', params: valid_attributes.to_json, headers: headers }
      # 새로운 유저 생성시
      it 'creates a new user' do
        expect(response).to have_http_status(201)
      end

      it 'returns success message' do
        expect(json['message']).to match(/Account created successfully/)
      end

      it 'returns an authentication token' do
        expect(json['auth_token']).not_to be_nil
      end
    end
    # 유효하지 않은 회원가입 요청
    context 'when invalid request' do
      before { post '/signup', params: {}, headers: headers }

      it 'does not create a new user' do
        expect(response).to have_http_status(422)
      end

      it 'returns failure message' do
        expect(json['message'])
          .to match(/Validation failed: Password can't be blank, Name can't be blank, Email can't be blank, Password digest can't be blank/)
      end
    end
  end
end
