class DocumentSigner < ActiveRecord::Base
  # Associations
  belongs_to :document
  belongs_to :user
end
