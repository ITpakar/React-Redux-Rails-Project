class Section < ActiveRecord::Base
  # Associations
  has_many   :tasks, dependent: :delete_all
  has_many   :comments, as: :commentable

  belongs_to :deal
  belongs_to :category
  belongs_to :creator, foreign_key: :created_by, class_name: 'User'
  
  def to_hash
    data = {
      section_id:  self.id,
      name:        self.name,
      category_id: self.category_id,
      activated:   self.activated
    }

    if self.deal_id
      data[:deal] = self.deal.to_hash
    end

    if self.creator
      data[:creator] = self.creator.to_hash(false)
    end

    return data
  end
end

