require 'factory_girl_rails'
require 'ffaker'

FactoryGirl.define do 
  factory :deal do
    
    transient do
      organization_user nil
    end

    title                 { FFaker::HipsterIpsum.word.titleize + ' Deal' }
    client_name           { FFaker::Name.name }
    transaction_type      { Deal::TRANSACTION_TYPES.sample }
    projected_close_date  { FFaker::Time.date }
    status                { Deal::STATUSES.sample }
    activated             true
    created_at            { DateTime.now }
    updated_at            { DateTime.now }
    deal_size             150000000
    organization_user_id  { organization_user.id }
    organization_id       { organization_user.organization_id }

    trait :with_collaborators do
      after(:create) do |instance, evaluator|

      end
    end
  end
end