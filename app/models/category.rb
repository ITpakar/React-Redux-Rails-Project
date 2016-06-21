class Category < ActiveRecord::Base
  include Traversable
  self.inheritance_column = 'name'

  # Validations
  validates(
    :name,
    length:{
      maximum: 100
    }
  )

  belongs_to :deal
  has_many   :comments, :as => :commentable
  has_many   :sections

  def to_hash
    sections = self.sections.map{|section| section.to_hash}

    return self.attributes.merge({
      sections: sections
    })
  end
end
