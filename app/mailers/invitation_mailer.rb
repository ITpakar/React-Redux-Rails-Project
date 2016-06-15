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
    @url = new_app_user_registration_url(token: deal_collaborator_invite.token)
    mail(to: deal_collaborator_invite.email, subject: 'Invitation to collaborate to the deal.')
  end

  def organization_invitation_email(name, email, organization)
    @name = name
    @email = email
    @organization = organization
    @url = new_app_user_registration_url
    mail(to: @email, subject: "You've been invited to join #{organization.name.capitalize} on Doxly")
  end
end
