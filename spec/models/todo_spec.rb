require 'rails_helper'

RSpec.describe Todo, type: :model do
  # Todo 모델과 Item 모델은 1:m 관계를 갖는데, 이를 위한 관계성 테스트
  it { should have_many(:items).dependent(:destroy) }

  # title과 created_by 컬럼 존재성 여부 테스트
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:created_by) }
end
