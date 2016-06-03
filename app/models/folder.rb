class Folder < ApplicationRecord
  include HasVisibility

  # Association
  belongs_to :organization_user, foreign_key: :created_by
  belongs_to :section
  # belongs_to :deal

  has_many :deal_documents, as: :documentable
  has_many :documents, through: :deal_documents
  has_many :comments, as: :commentable

  # after_create :set_deal

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
