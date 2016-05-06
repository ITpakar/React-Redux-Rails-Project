class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # user role validate
  def authenticate_super_admin
    return true
    if current_user.blank? or !current_user.has_role?(SUPER_ADMIN)
      unauthorized_response
    end
  end

  def authenticate_organization_admin
    if current_user.blank? or !current_user.is_organzation_admin?(params[:organization_id])
      unauthorized_response
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

  def error_response(messages, status = 422)
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

  def unauthorized_response
    render(
      json: {
        status: 'unauthorized',
        data: nil,
        errors: {
          messages: ['You are unauthorized to access this page.']
        }
      },
      status: 401
    )
  end
end
