class Comment < ActiveRecord::Base
  # Associations
  belongs_to :user
  belongs_to :task, required: false
  belongs_to :document, required: false

  before_validation :set_deal_id, unless: :deal_id

  def set_deal_id
    self.deal_id = (self.try(:task).try(:deal_id) || self.try(:document).try(:deal_id)) 
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
