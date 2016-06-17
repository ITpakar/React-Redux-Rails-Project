class DocumentSigner < ApplicationRecord
  belongs_to :deal_document

  def to_hash
    return {
      name: self.name, 
      email: self.email,
    }
  end
end
