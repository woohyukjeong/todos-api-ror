class TodosController < ApplicationController
  before_action :set_todo, only: [:show, :update, :destroy]

  def index
    @todos = current_user.todos
    json_response(@todos)
  end

  def show
    json_response(@todo)
  end

  def update
    @todo.update(todo_params)
    json_response(@todo, :ok)
  end

  def destroy
    Todo.delete(@todo)
    head :no_content
  end

  def create
    @todo = current_user.todos.create!(todo_params)
    json_response(@todo, :created)
  end

  # 컨트롤러 클래스 내부에서만 사용할 수 있도록 제한
  private

  # Parameter 유효성 검증을 위한 메서드
  def todo_params
    # Strong Parameters 기능을 활용하여 title  필드만 요청의 매개변수로 허용
    # 허용되지 않는 매개변수는 제거된다
    params.permit(:title)
  end

  def set_todo
    @todo = current_user.todos.find(params[:id])
  end
end
