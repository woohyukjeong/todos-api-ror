class ApplicationController < ActionController::API
  include Response
  include ExceptionHandler

  # API 요청에 의해 Controller 로직에 들어가기전 유효
  before_action :authorize_request
  # 클래스 내부에 읽기전용 인스턴스 변수를 생성
  attr_reader :current_user

  private

  # 파라미터 유효성 검증 메서드
  def permitted_params(required = [], optional = [])
    required.each { |param| params.require(param)}
    params.permit(*required, *optional)
  end

  # 토큰을 검증하고 User 정보를 리턴
  def authorize_request
    @current_user = (AuthorizeApiRequest.new(request.headers).call)[:user]
  end
end
