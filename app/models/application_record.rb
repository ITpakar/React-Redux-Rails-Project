class ApplicationRecord < ActiveRecord::Base
  include Traversable

  self.abstract_class = true
  
  def set_deal
    self.deal_id = self.traverse_up_to(Deal).try(:id)
    save
  end
end