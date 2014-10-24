FactoryGirl.define do

  factory :history, class: History do
    sequence(:id) { |n| n+10001000 }
    sequence(:video_id) { |n| n+10002000 }
    sequence(:keyword) { |n| "hogehoge#{n}" }
  end

end
