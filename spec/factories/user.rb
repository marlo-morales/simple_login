FactoryBot.define do
  factory :user do
    username { Faker::FunnyName.unique.name.gsub(' ', '_').downcase }
    password { 'Password123' }

    trait :locked do
      access_failed_count { User::ACCESS_FAILED_MAX_COUNT }
      access_locked_at { Time.current }
    end
  end
end
