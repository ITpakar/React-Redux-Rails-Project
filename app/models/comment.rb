class Comment < ActiveRecord::Base
  # Associations
  belongs_to :user
  belongs_to :task, required: false
  belongs_to :document, required: false

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
