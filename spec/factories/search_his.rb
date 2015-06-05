FactoryGirl.define do
  factory :search_his, class: SearchHis do
    favs 'no'
    duration 'no'
    sequence(:user_id)
    keyword '姉妹'
  end
end
