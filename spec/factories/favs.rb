FactoryGirl.define do

  factory :fav, class: Fav do
    user_id 1
    comment "foocommendbar"
    sequence(:video_id) { |n| n+10001001 }
  end

  factory :fav1, class: Fav do
    user_id 1
    comment "foocommendbar"
    video_id 10001000
  end

  factory :fav4his, class: Fav do
    user_id 1
    comment "foocommendbar"
    sequence(:video_id) { |n| n+10002000 }
  end

end
