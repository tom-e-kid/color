namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    User.create!(name: "admin", email: "admin@example.com", password: "foobar", password_confirmation: "foobar", admin: true)

    99.times do |n|
      name = "user_#{n+1}"
      email = "user_-#{n+1}@example.com"
      password = "password"
      User.create!(name: name, email: email, password: password, password_confirmation: password)
    end
  end
end