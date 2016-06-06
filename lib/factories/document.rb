require 'factory_girl_rails'
require 'ffaker'

FactoryGirl.define do 

  factory :deal_document do
    document_id 0
    documentable nil
  end

  factory :document do
    transient do
      organization_user nil
    end

    title                 { FFaker::HipsterIpsum.word.titleize + ' Document' }
    file_name             { FFaker::Name.name}
    file_type             { Document::FILE_TYPES.sample }
    file_size             150000000
    activated             true
    file_uploaded_at      { DateTime.now }
    created_at            { DateTime.now }
    updated_at            { DateTime.now }
    created_by            { organization_user.id }

    trait :with_documentables do
      ignore do
        documentables nil
      end

      after(:create) do |instance, evaluator|
        evaluator.documentables.each do |documentable|
          create(:deal_document, documentable: documentable, document_id: instance.id)  
        end
      end
    end
  end
end