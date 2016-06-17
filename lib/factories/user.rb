require 'factory_girl_rails'
require 'ffaker'

FactoryGirl.define do 
  factory :user do
    transient do 
      email_domain { FFaker::Internet.domain_name }
      organization_id nil
    end

    first_name      { FFaker::Name.first_name }
    last_name       { FFaker::Name.last_name }
    phone           { FFaker::PhoneNumber.short_phone_number }
    password        '12345678'
    email           { first_name + "@#{email_domain}" }
    created_at      { DateTime.now }
    updated_at      { DateTime.now }
    role            "Normal"
    activated       true
    avatar_name    { "/assets/img-avatar-#{[1, 2, 3, 4, 5, 6].sample}.png" }
    avatar          { Rack::Test::UploadedFile.new(File.join(Rails.root, 'app', 'assets' ,'images' , "img-avatar-#{[1, 2, 3, 4, 5, 6].sample}.png")) }

    trait :with_organization_user do
      after(:create) do |instance, evaluator|
        OrganizationUser.create(
          user_id: instance.id, 
          organization_id: evaluator.organization_id)
      end
    end

    trait :with_confirmed_email do
      after(:create) do |instance, evaluator|
        instance.confirm!
      end
    end
  end
end