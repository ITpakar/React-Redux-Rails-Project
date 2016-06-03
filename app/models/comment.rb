class Comment < ApplicationRecord
  include Traversable

  # Things you can comment on
  # - Deal
  # - Category
  # - Section
  # - Task
  # - Folder
  # - Document

  belongs_to :organization_user
  # belongs_to :deal
  belongs_to :commentable, polymorphic: true
  has_many   :events, as: :eventable

  # after_save :set_deal, :create_event

  def create_event
    Event.create(deal_id: self.deal_id, action: "COMMENT_ADDED", eventable: self)
  end

  def set_deal
    deal = self.traverse_up_to(Deal)
    self.deal_id = deal.id
    self.save
  end

  def to_hash
    data = {
      comment_id:   self.id,
      comment_type: self.comment_type,
      comment:      self.comment
    }
    if self.organization_user
      data[:user] = self.organization_user.user.to_hash(false)
    end

    return data
  end
end
