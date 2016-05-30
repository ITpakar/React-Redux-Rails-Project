class Comment < ApplicationRecord

  # Things you can comment on
  # - Deal
  # - Category
  # - Section
  # - Task
  # - Folder
  # - Document

  belongs_to :user
  belongs_to :commentable, polymorphic: true

  after_create :create_event

  def deal

  end

  def create_event
    Event.create(deal_id: self.deal_id, action: "COMMENT_ADDED", subject_type: "Comment", subject_id: self.id)
  end

  def to_hash
    data = {
      comment_id:   self.id,
      comment_type: self.comment_type,
      comment:      self.comment
    }
    if self.user
      data[:user] = self.user.to_hash(false)
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
