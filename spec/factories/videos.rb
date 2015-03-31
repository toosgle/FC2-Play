FactoryGirl.define do

  factory :video, class: Video do
    sequence(:id) { |n| n+10001000 }
    sequence(:title) { |n| "f*ckingtosh#{n}" }
    sequence(:url) { |n| "http://video.fc2.com/hogehogehuu#{n}" }
    sequence(:views) { |n| n }
    duration "10:23"
    adult true
    sequence(:image_url) { |n| "http://image.video.fc2.com/hogehogehuu#{n}" }
    morethan100min false
    sequence(:bookmarks) { |n| n*100 }
  end

  factory :video1, class: Video do
    id 20001001
    title "f*ckingosh"
    url "http://video.fc2.com/hogehogehu"
    views 3456
    duration "10:23"
    adult true
    image_url "http://image.video.fc2.com/hogehogehuu"
    morethan100min false
    bookmarks 1234
  end

  factory :video4his, class: Video do
    sequence(:id) { |n| n+20001000 }
    sequence(:title) { |n| "f*ckingosh_#{n}" }
    url "http://video.fc2.com/hogehogehu"
    views 3456
    duration "10:23"
    adult true
    image_url "http://image.video.fc2.com/hogehogehuu"
    morethan100min false
    bookmarks 1234
  end

  factory :video4newarrival, class: Video do
    sequence(:id) { |n| n+10002000 }
    sequence(:title) { |n| "f*ckingosh_#{n}" }
    url "http://video.fc2.com/hogehogehu"
    sequence(:views) {|n| n*n*n*10+3456}
    duration "10:23"
    adult true
    image_url "http://image.video.fc2.com/hogehogehuu"
    morethan100min false
    sequence(:bookmarks) {|n| n+1234}
  end

end
