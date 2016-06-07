class DealDocument < ApplicationRecord
  include Traversable
  belongs_to :document
  belongs_to :documentable, polymorphic: true
  belongs_to :deal

  has_many :comments, as: :commentable

  before_validation :set_deal, on: :create
  after_create :set_deal

  def set_deal
    self.deal_id ||= self.traverse_up_to(Deal).try(:id)
  end
end
