require 'factory_girl_rails'
require 'ffaker'


FactoryGirl.define do 
  factory :organzation do
    # Need to specify organization_id
    title           { FFaker::HipsterIpsum.word.titleize + ' Deal' }
    email_domain    { Organization.find(organization_id).email_domain }
    phone           { FFaker::PhoneNumber.phone_number }
    address         { FFaker::Address.street_address }
    activated       'true'
    created_at      { DateTime.now }
    updated_at      { DateTime.now }
  end
end