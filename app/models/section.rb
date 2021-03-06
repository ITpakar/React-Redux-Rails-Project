class Section < ApplicationRecord
  include Traversable
  include HasVisibility
  # Associations

  belongs_to :category
  belongs_to :deal
  belongs_to :creator, foreign_key: :created_by, class_name: 'OrganizationUser'
  has_many   :tasks
  has_many   :deal_documents, as: :documentable
  has_many   :documents, through: :deal_documents
  has_many   :comments,  :as => :commentable

  before_validation :set_deal, on: :create

  def set_deal
    self.deal_id = self.category.deal_id unless self.deal_id
  end

  def to_hash 
    tasks = self.tasks.map{|task| task.to_hash}

    data = {
      section_id:  self.id,
      name:        self.name,
      category_id: self.category_id,
      activated:   self.activated,
      tasks:       self.tasks.map(&:to_hash)
    }

    if self.deal_id
      data[:deal] = self.deal.to_hash
    end

    if self.creator
      data[:creator] = self.creator.user.to_hash(false)
    end

    return data
  end

  def section
    self
  end
end
