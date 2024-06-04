require 'rails_helper'

RSpec.describe "Items API", type: :request do
  # Initialize Test Data
  let!(:user) { create(:user) }
  let!(:todo) { create(:todo, created_by: user.id) }
  let!(:items) { create_list(:item, 20, todo_id: todo.id) }
  let(:todo_id) { todo.id }
  let(:id)  { items.first.id }
  let(:headers) { valid_headers }
  let(:post_headers) { {
    "Authorization" => token_generator(user.id),
    "Content-Type" => "application/x-www-form-urlencoded"
  } }

  # POST /todos/:todo_id/items 테스트 케이스
  describe "POST /todos/:todo_id/items" do
    # Params 초기화
    let(:valid_attributes) {{ name: Faker::Mountain.name, done: false }}
    let(:invalid_attributes) {{done: true, todo_id: -1}}

    # Todo Item이 존재할 때
    context "when todo item exists" do
      # 유효한 파라미터일 경우
      context "with valid attributes" do

        before { post "/todos/#{todo_id}/items", params: valid_attributes, headers: post_headers  }
        # 성공한 케이스
        # status 200 리턴
        # response에 id값이 nil이 아닐 것
        it 'creates a item' do
          expect(response).to have_http_status(200)
          expect(json['id']).not_to be_nil
        end

      end
      # 유효하지 않은 파라미터일 경우
      context "with invalid attributes" do
        before { post "/todos/#{todo_id}/items", params: invalid_attributes, headers: post_headers }
        # 400 에러를 리턴
        it "returns 400 Bad Request" do
          expect(response).to have_http_status(400)
        end
      end
    end

    # Todo Item이 존재하지 않을 때
    context "when todo item does not exist" do
      # 유효한 파라미터일 경우
      context "with valid attributes" do
        before { post "/todos/#{todo_id}/items", params: valid_attributes, headers: post_headers }
        let(:todo_id) { 9999 }
        it "returns 404 Not Found" do
          expect(response.status).to eq(404)
        end
      end

      # 유효하지 않은 파라미터의 경우
      context "with invalid attributes" do
        before { post "/todos/#{todo_id}/items", params: invalid_attributes, headers: post_headers }
        it "returns 400 Bad Request" do
          expect(response).to have_http_status(400)
        end
      end
    end
  end

  # GET /todos/:todo_id/items 테스트 케이스
  describe "GET /todos/:todo_id/items" do
    let!(:todo){ create(:todo, created_by: user.id) }
    let!(:items) { create_list(:item, 20, todo_id: todo.id) }
    let(:todo_id) { todo.id }


    # todo item이 존재하는 경우
    context "when todo item exists" do
      before { get "/todos/#{todo_id}/items", params: {}, headers: headers }
      it "should return all items" do
        expect(json.size).to eq(20)
      end

      it "responds with 200 OK" do
        expect(response).to have_http_status(200)
      end
    end

    # todo item이 존재하지 않는 경우
    context "when todo item does not exist" do
      before { get "/todos/#{todo_id}/items", params: {}, headers: headers }
      let(:todo_id) { 9999 }
      it "returns 404 Not Found" do
        expect(response).to have_http_status(404)
      end
    end
  end

  # GET /todos/:todo_id/items/:id 테스트 케이스
  describe "GET /todos/:todo_id/items/:id" do
    let!(:todo){ create(:todo) }
    let(:todo_id) { todo.id }
    let!(:item) { create(:item, todo_id: todo.id) }
    let(:id) { item.id }

    context "when item exists" do
      before { get "/todos/#{todo_id}/items/#{id}", params: {}, headers: headers }

      it "should return the requested item" do
        # eql? 메서드는 두 객체가 동일한 값을 가지는지 검사
        # ==와 비슷하지만 eql?은 객체의 타입도 비교
        expect(json['id']).to eq(item.id)
      end

      it "responds with 200 OK" do
        expect(response).to have_http_status(200)
      end
    end

    context "when item does not exist" do
      before { get "/todos/#{todo_id}/items/#{id}", params: {}, headers: headers }

      let(:id) { 9999 }
      it "returns 404 Not Found" do
        expect(response).to have_http_status(404)
      end
    end
  end

  # PUT /todos/:todo_id/items/:id 테스트 케이스
  describe "PUT /todos/:todo_id/items/:id" do
    let!(:todo){ create(:todo) }
    let(:todo_id) { todo.id }
    let!(:item) { create(:item, todo_id: todo.id) }
    let(:id) { item.id }
    let(:valid_attributes) {{ name: Faker::Mountain.name, done: true }}

    context "when item exists" do
      before { put "/todos/#{todo_id}/items/#{id}", params: valid_attributes, headers: post_headers }
      it "returns 200 OK" do
        expect(response).to have_http_status(200)
      end

      it "returns same item id which is requested in path" do
        expect(json["id"]).to eq(item.id)
      end
    end

    context "when item does not exist" do
      before { put "/todos/#{todo_id}/items/#{id}", params: valid_attributes, headers: post_headers }
      let(:id) { 9999 }
      it "returns 404 Not Found" do
        expect(response).to have_http_status(404)
      end
    end
  end

  # DELETE /todos/:todo_id/items/:id 테스트 케이스
  describe "DELETE /todos/:todo_id/items/:id" do
    let!(:todo){ create(:todo) }
    let(:todo_id) { todo.id }
    let!(:item) { create(:item, todo_id: todo.id) }
    let(:id) { item.id }

    context "when item exists" do
      before { delete "/todos/#{todo_id}/items/#{id}", params: {}, headers: headers }

      it "returns 204 No Content" do
        expect(response).to have_http_status(204)
      end
    end

    context "when item does not exist" do
      before { delete "/todos/#{todo_id}/items/#{id}", params: {}, headers: headers }
      let(:id) { 9999 }
      it "returns 404 Not Found" do
        expect(response).to have_http_status(404)
      end
    end
  end
end
