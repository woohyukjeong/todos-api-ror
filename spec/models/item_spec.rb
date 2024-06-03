require 'rails_helper'

# Test Suite for the Item Model
RSpec.describe Item, type: :model do
  # item record가 하나의 todo record에 속하는지 관계성 검사
  it { should belong_to(:todo) }

  # name 컬럼이 존재하는지 유효성 검사
  it { should validate_presence_of(:name) }
end
