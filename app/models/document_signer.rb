class DocumentSigner < ActiveRecord::Base
  # Associations
  belongs_to :document
  belongs_to :organization_user

  def to_hash
    return self.document.to_hash
  end
end
