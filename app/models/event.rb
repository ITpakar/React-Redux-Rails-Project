class Event < ApplicationRecord
  ACTIONS = ['COMMENT_ADDED', 
             'DOCUMENT_SIGNED', 
             'DOCUMENT_CREATED', 
             'DOCUMENT_UPDATED', 
             'COLLABORATOR_INVITED', 
             'COLLABORATOR_ACCEPTED', 
             'TASK_COMPLETED', 
             'DEAL_CLOSED']

  HEADINGS = {
    'COMMENT_ADDED' => "Comment Added",
    'DOCUMENT_SIGNED' => "Document Signed",
    'DOCUMENT_CREATED' => "Document Uploaded",
    'DOCUMENT_UPDATED' => "New Document Version Uploaded",
    'COLLABORATOR_INVITED' => "Collaborator Invited",
    'COLLABORATOR_ACCEPTED' => "Collaborator Added",
    'TASK_COMPLETED' => "Task Completed",
    'DEAL_CLOSED' => "Deal Closed"
  }

  # Still need to implement
  # DOCUMENT_SIGNED
  # DOCUMENT_CREATED
  # DOCUMENT_UPDATED
  # COLLABORATOR_INVITED
  # COLLABORATOR_ACCEPTED

  belongs_to :deal
  belongs_to :eventable, polymorphic: true

  before_validation :set_deal, on: :create

  def set_deal
    self.deal_id ||= self.eventable.traverse_up_to(Deal).try(:id)
  end

  def title
    HEADINGS[self.action]
  end

  def date
    self.created_at.strftime("%-m/%d/%Y")
  end
end