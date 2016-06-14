class DealDocument < ApplicationRecord
  include Traversable
  belongs_to :document
  belongs_to :documentable, polymorphic: true
  belongs_to :deal

  has_many :comments, as: :commentable
  has_many :versions, class_name: 'DealDocumentVersion'

  before_validation :set_deal, on: :create
  after_create :set_deal

  def set_deal
    self.deal_id ||= self.traverse_up_to(Deal).try(:id)
  end

  def to_hash(box_client = nil)
    data = {
      id:                self.id,
      deal_id:           self.deal_id,
      document_id:       self.document_id,
      documentable_id:   self.documentable_id,
      documentable_type: self.documentable_type
    }

    if box_client.present? && self.box_file_id.present?
      box_file = box_client.file_from_id(self.box_file_id)
      data[:url] = box_client.download_url(box_file)
    end

    data[:versions] = []
    self.versions.each do |version|
      data[:versions] << version.to_hash(box_client)
    end

    return data
  end
end
