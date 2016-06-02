class Comment < ApplicationRecord
  include Traversable

  # Things you can comment on
  # - Deal
  # - Category
  # - Section
  # - Task
  # - Folder
  # - Document

  belongs_to :organization_user
  belongs_to :deal
  belongs_to :commentable, polymorphic: true
  has_many   :events, as: :trigger

  after_create :create_event, :set_deal

  def create_event
    Event.create(deal_id: self.deal_id, action: "COMMENT_ADDED", trigger: self)
  end

  def to_hash
    data = {
      comment_id:   self.id,
      comment_type: self.comment_type,
      comment:      self.comment
    }
    if self.user
      data[:user] = self.organization.user.to_hash(false)
    end

    if self.task
      data[:task] = self.task.to_hash
    end

    if self.document
      data[:document] = self.document.to_hash
    end

    return data
  end
end
