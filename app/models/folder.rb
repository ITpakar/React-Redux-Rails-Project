class Folder < ApplicationRecord
  include Traversable
  include HasVisibility

  # Association
  belongs_to :organization_user, foreign_key: :created_by
  belongs_to :task
  belongs_to :deal

  has_many :deal_documents, as: :documentable
  has_many :documents, through: :deal_documents
  has_many :comments, as: :commentable

  after_create :set_deal

  def set_deal
    deal = self.traverse_up_to(Deal)
    self.deal_id = deal.id
    self.save
  end

  def creator
    self.organization_user
  end

  def to_hash
    data = {
      name:        self.name,
      parent_type: self.parent_type,
      parent_id:   self.parent_id,
      activated:   self.activated
    }

    if self.organization_user
      data[:creator] = self.organization_user.to_hash(false)
    end

    return data
  end
end
