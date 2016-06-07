class InvitationMailer < ApplicationMailer
  default from: 'invitation@doxly.com'

  def invitation_email(user, organization_user)
    @user = user
    @organization_user = organization_user
    @url  = 'http://doxly.com/accept-ivitation/' + @organization_user.invitation_token
    mail(to: @user.email, subject: 'Invitation to join in our organization.')
  end

  def collaborator_invitation_email(deal, organization_user, invitation_token)
    @organization_user = organization_user
    @user = organization_user.user
    @url  = 'http://doxly.com/accept-collaborator-invitation/' + invitation_token
    mail(to: @user.email, subject: 'Invitation to collaborate to the deal.')
  end
end
