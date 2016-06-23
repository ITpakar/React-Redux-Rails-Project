class Notification < ActiveRecord::Base
  # Associations
  belongs_to :organization_user

  def to_hash
    data = {
      notification_id: self.id,
      message:         self.message,
      status:          self.status
    }
    if self.organization_user && self.organization_user.user
      data[:user] = self.organization_user.user.to_hash(false)
    end

    return data
  end
end
