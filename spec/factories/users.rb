FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@mail.com" }
    password { 'password' }
    is_librarian { true }
  end
end
