class DealDocumentVersion < ApplicationRecord
  include Traversable
  belongs_to :deal_document

  before_create :set_name

  def set_name
    self.deal_document.versions.order('created_at DESC').each do |version|
      self.name = (version.name.to_f + 1).to_s
      break
    end
  end

  def to_hash
    data = {
      id:               self.id,
      name:             self.name,
      url:              self.url,
      download_url:     self.download_url,
      created_at:       self.created_at,
      changes: []
    }

    return data
  end
end
