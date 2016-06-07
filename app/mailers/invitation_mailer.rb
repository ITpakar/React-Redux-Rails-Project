class InvitationMailer < ApplicationMailer
  default from: 'invitation@doxly.com'

  def invitation_email(user, organization_user)
    @user = user
    @organization_user = organization_user
    @url  = 'http://doxly.com/accept-ivitation/' + @organization_user.invitation_token
    mail(to: @user.email, subject: 'Invitation to join in our organization.')
  end

  def collaborator_invitation_email(deal_collaborator_invite)
    @deal_collaborator_invite = deal_collaborator_invite
    @url = deal_collaborator_invite_url(deal_collaborator_invite)
    mail(to: deal_collaborator_invite.email, subject: 'Invitation to collaborate to the deal.')
  end
end
