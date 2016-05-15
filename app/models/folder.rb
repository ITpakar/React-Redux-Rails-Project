class Folder < ApplicationRecord
  # Association
  belongs_to :user, foreign_key: :created_by

  def to_hash
    data = {
      name:        self.name,
      parent_type: self.parent_type,
      parent_id:   self.parent_id,
      activated:   self.activated
    }

    if self.user
      data[:creator] = self.user.to_hash(false)
    end

    return data
  end
end
