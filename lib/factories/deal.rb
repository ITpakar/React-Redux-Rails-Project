require 'factory_girl_rails'
require 'ffaker'

FactoryGirl.define do 
  factory :deal do
    transient do
      organzation nil
      organization_user nil
    end
    name            { FFaker::Company.name }
    email_domain    { organization.email_domain }
    client_name     { FFaker::Name.name }
    transaction_type { Deal::TRANSACTION_TYPES.sample }
    projected_close_date { FFaker::Time.date }
    status          { Deal::STATUSES.sample }
    activated       true
    created_at      { DateTime.now }
    updated_at      { DateTime.now }
    deal_size       150000000
    organization_user_id { organization_user.id }
  end
end