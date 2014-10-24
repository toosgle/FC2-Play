FactoryGirl.define do

  factory :user, class: User do
    name "testRspec"
    password "password"
    password_confirmation "password"
    size 750
  end

end
