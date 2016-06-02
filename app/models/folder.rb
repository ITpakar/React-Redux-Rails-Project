class Folder < ApplicationRecord

  # Association
  belongs_to :organization_user, foreign_key: :created_by
  belongs_to :parent, polymorphic: true
  belongs_to :deal

  has_many :documents, as: :documentable
  has_many :comments, as: :commentable

  after_create :set_deal

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

  def deal
    Deal.find(parent.deal_id)
  end
end
