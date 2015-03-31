FactoryGirl.define do

  factory :history4wrank, class: History do
    sequence(:id) { |n| n+10001000 }
    sequence(:video_id) { |n| n+10002000 }
    sequence(:keyword) { |n| "hogehoge#{n}" }
    sequence(:user_id) { |n| n }
  end


  factory :history, class: History do
    sequence(:id) { |n| n+20001000 }
    sequence(:video_id) { |n| n+20001000 }
    sequence(:keyword) { |n| "hogehoge#{n}" }
    sequence(:user_id) { |n| n }
  end

  factory :history4limit, class: History do
    sequence(:id) { |n| n+30001000 }
    sequence(:video_id) { |n| n+20002000 }
    sequence(:keyword) { |n| "hogehoge#{n}" }
  end

end
