require 'rails_helper'

RSpec.describe "Todos", type: :request do
  # Test Data 초기화
  # User 정보 초기화
  let(:user) { create(:user) }
  # !가 붙어서 즉시 초기화 진행. 각 테스트가 실행되기 전에 값을 즉시 초기화
  # let!은 테스트 실행전에 미리 값을 설정해야 할 때 사용한다. 여럴 테스트에서 공통으로 사용하는 값 초기화시 쓴다.
  let!(:todos) { create_list(:todo, 10, created_by: user.id) }

  # 지연 초기화. 처음으로 접근할 때까지 값을 초기화하지 않는다
  # let은 값이 필요할 때만 초기화할 때 사용한다
  let(:todo_id) { todos.first.id }

  # 인증관련 헤더 데이터
  let(:headers) { valid_headers }
  let(:post_headers) { {
    "Authorization" => token_generator(user.id),
    "Content-Type" => "application/x-www-form-urlencoded"
  } }

  # GET /todos에 대한 테스트 케이스
  describe 'GET /todos' do
    # 모든 테스트 케이스를 시작하기 전에 GET 요청을 실행
    # before가 없으면 한번의 GET 요청을 진행하고, 그 응답값으로 모든 테스트케이스 검증 수행
    # 각 테스트의 독립성을 보장하기 위해 before 블록을 사용하는 것이 일반적인 권장사항
    before { get '/todos', params: {}, headers: headers }

    it 'returns todos' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

  end

  # GET /todos/:id에 대한 테스트 케이스
  describe 'GET /todos/:id' do
    before { get "/todos/#{todo_id}", params: {}, headers: headers }

    # Context와 it은 테스트를 구조화하고 명확하게 하기 위해 사용
    # Context는 특별 조건이나 상황을 설명하는데 사용. it 블록을 그룹화하는데 주로 사용
    # it은 개별 테스트 케이스를 정의할 때 사용
    context 'when the record exists' do
      it 'returns the todo' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(todo_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      # 존재하지 않는 todo_id 설정
      let(:todo_id) { 999 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Todo/)
      end
    end
  end

  # POST /todos 테스트 케이스
  describe 'POST /todos' do
    # 유효한 payload 설정
    let(:valid_attributes) { { title: 'First_Todo'} }
    # 유효하지 않은 payload 설정
    let(:invalid_attributes) { { title: 'Invalid_Todo' } }

    context 'when the request is valid' do
      before { post '/todos', params: valid_attributes, headers: post_headers }

      it 'creates a todo' do
        expect(json['title']).to eq('First_Todo')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end
  end

  # PUT /todos 테스트 케이스
  describe 'PUT /todos/:id' do
    let(:valid_attributes) { { title: 'Modified Todo'} }

    context 'when the record exists' do
      before { put "/todos/#{todo_id}", params: valid_attributes, headers: post_headers }
      it 'updates the record' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:todo_id) { 999 }
      before { put "/todos/#{todo_id}", params: valid_attributes, headers: post_headers }
      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end

  # DELETE /todos/:id 테스트 케이스
  describe 'DELETE /todos/:id' do
    before { delete "/todos/#{todo_id}", params: {}, headers: headers }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
