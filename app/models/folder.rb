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

  before_validation :set_deal, on: :create

  def set_deal
    self.deal_id ||= self.traverse_up_to(Deal).try(:id)
  end

  def creator
    self.organization_user
  end

  def to_hash
    data = {
      name:        self.name,
      activated:   self.activated
    }

    if self.organization_user
      data[:creator] = self.organization_user.to_hash
    end

    return data
  end

  def section
    self.task.section
  end
end
