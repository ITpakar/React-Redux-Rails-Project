class DealDocument < ApplicationRecord
  include Traversable
  belongs_to :document
  belongs_to :documentable, polymorphic: true

  has_many :comments, as: :commentable

  after_create :set_deal

  def set_deal
    self.deal_id ||= self.traverse_up_to(Deal).try(:id)
    self.save
  end
end
