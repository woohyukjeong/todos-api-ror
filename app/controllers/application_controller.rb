class ApplicationController < ActionController::API
  include Response
  include ExceptionHandler

  # 파라미터 유효성 검증 메서드
  def permitted_params(required = [], optional = [])
    required.each { |param| params.require(param)}
    params.permit(*required, *optional)
  end
end
