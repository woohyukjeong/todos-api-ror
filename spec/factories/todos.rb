# FactoryBot으로 Todo 아이템 생성 정의

FactoryBot.define do
  factory :todo do
    title { Faker::Lorem.word }
    # created_by { Faker::Number.number(digits: 10) }
    created_by { (create(:user)).id }
  end
end