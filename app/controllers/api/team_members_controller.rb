class Api::TeamMembersController < ApplicationController
  respond_to :json

  def create
    form = TeamMemberForm.new(team_member_params.merge(:organization => current_organization))

    if form.valid?
      InvitationMailer.organization_invitation_email("#{form.first_name} #{form.last_name}", form.email, current_organization).deliver_later
      success_response({:success => true})
    else
      error_response(form.errors)
    end
  end

  private
  def team_member_params
    params.require(:team_member).permit(
      :first_name,
      :last_name,
      :email
    )
  end
end
