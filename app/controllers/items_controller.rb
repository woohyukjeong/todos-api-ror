class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :update, :destroy,]
  before_action :set_todo, only: [:create, :index]

  def show
    json_response @item, :ok
  end

  def update
    validate_params = validate_items_params_for_update
    @item.update!(validate_params)
    json_response @item, :ok
  end

  def destroy
    @item.destroy
    head :no_content
  end
  # items 생성
  def create
    @item = @todo.items.create!(validate_items_params_for_create)
    json_response @item, :ok
  end

  def index
    items = @todo.items
    json_response items, :ok
  end

  private

  # 필수 파라미터 유효성 검증
  def validate_items_params_for_create
    permitted_params([:name, :todo_id], [])
  end

  def validate_items_params_for_update
    permitted_params([],  [:name, :todo_id, :done])
  end

  # Todo Item 설정 Filter 메서드
  def set_todo
    @todo = Todo.find(params[:todo_id])
  end

  # Item 설정 Filter 메서드
  def set_item
    @item = Item.find(params[:id])
  end
end
