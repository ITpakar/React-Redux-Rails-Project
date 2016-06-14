class DealDocumentVersion < ApplicationRecord
  include Traversable
  belongs_to :deal_document

  
end
