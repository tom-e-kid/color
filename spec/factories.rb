FactoryGirl.define do
  factory :user do
  	name		"test_user"
  	email		"test_user@example.com"
  	password	"foobar"
  	password_confirmation "foobar"
  end
end