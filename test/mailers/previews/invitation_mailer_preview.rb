# Preview all emails at http://localhost:3000/rails/mailers/invitation_mailer
class InvitationMailerPreview < ActionMailer::Preview
  def collaborator_invitation_email
    InvitationMailer.collaborator_invitation_email(Deal.first, OrganizationUser.first)
  end
end
