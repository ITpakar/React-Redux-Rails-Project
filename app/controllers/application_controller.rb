class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # user role validate
  def authenticate_user!
    if current_user.blank?
      unauthorized_response(401)
    end
  end

  def authenticate_super_admin!
    if current_user.blank? or !current_user.is_super?
      unauthorized_response(403)
    end
  end

  def authenticate_organization_admin!
    if current_user.blank? or !current_user.is_organzation_admin?(params[:id])
      unauthorized_response(403)
    end
  end

  def authenticate_organization_member!
    if current_user.blank? or !current_user.is_organzation_member?(params[:id])
      unauthorized_response(403)
    end
  end

  def authentication_org_deal_admin!
    if current_user.blank? or !current_user.is_org_deal_admin?(params[:deal_id])
      unauthorized_response(403)
    end
  end

  def authentication_deal_collaborator!
    if current_user.blank? or !current_user.is_deal_collaborator?(params[:deal_id])
      unauthorized_response(403)
    end
  end

  def authentication_deal_collaborators!
    if current_user.blank? or !current_user.is_deal_collaborator?(params[:id])
      unauthorized_response(403)
    end
  end

  def authenticate_document_owner!
    if current_user.blank? or !current_user.is_document_owner?(params[:document_id])
      unauthorized_response(403)
    end
  end

  def authenticate_notification_reciever!
    if current_user.blank? or !current_user.is_notification_reciever?(params[:id])
      unauthorized_response(403)
    end
  end

  # API responses
  def success_response(data, status = 200)
    render(
      json: {
        status: 'success',
        data: data,
        errors: nil,
      },
      status: status
    )
  end

  def error_response(messages, status = 406)
    render(
      json: {
        status: 'error',
        data: nil,
        errors: {
          messages: messages
        }
      },
      status: status
    )
  end

  def error_validation_response(messages, status = 400)
    render(
      json: {
        status: 'error',
        data: nil,
        error: {
          messages: messages
        }
      },
      status: status
    )
  end

  def unauthorized_response(status)
    render(
      json: {
        status: 'unauthorized',
        data: nil,
        errors: {
          messages: ['You are unauthorized to access this page.']
        }
      },
      status: status
    )
  end

  def ensure_params_exist(object)
    if params[object].blank?
      error_response(["object related parameters not found."])
    end
  end

  # Other support
  def set_peginate
    @per_page = (params[:per_page].to_i <= 0 ? PER_PAGE : params[:per_page].to_i)
    @page = (params[:page].to_i <= 0 ? 1 : params[:page].to_i)
  end
end
