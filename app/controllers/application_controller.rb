class ApplicationController < ActionController::API
    include ActionController::HttpAuthentication::Token::ControllerMethods
    include ActionController::MimeResponds

    around_action :set_connection, :if => proc { params[:db].present? }
    before_action :require_login!
    after_action :set_access_control_headers
    helper_method :user_signed_in?, :current_user

    #rescue_from StandardError, with: :standard_error
    #rescue_from ActiveRecord::RecordNotFound, with: :not_found
    #rescue_from ActiveRecord::RecordInvalid, with: :invalid_record
    #rescue_from ActiveRecord::StatementInvalid, with: :error_clave_foranea

    def set_access_control_headers
        headers['Access-Control-Allow-Origin']='*'
    end
    
    protected

    def set_connection
        begin
            old_db = ApplicationRecord.connection_config[:database]
            ApplicationRecord.switch_connection(params[:db])
            Rails.logger.info "Switched connection to #{params[:db]}"
            yield
        ensure
            Rails.logger.info "Switched connection back to #{old_db}"
            ApplicationRecord.switch_connection(old_db)
        end
    end

    def user_signed_in?
        current_user.present?
    end

    def require_login!
        return true if authenticate_token
        render json: { errors: [ { detail: "Acceso denegado" } ] }, status: 401
    end

    def current_user
        @_current_user ||= authenticate_token
    end

    def validate_resource!(resource)
      return true unless resource.errors.present?
      render status: :bad_request, json: { errors: resource.errors.messages }
      false
    end

    def standard_error(error)
        render status: :bad_request, json: { error: error.message }
    end
  
    def not_found(error)
        render status: :not_found, json: { error: error.message }
    end

    def invalid_record(error)
        render status: :not_acceptable, json: { error: error.message }
    end

    def error_clave_foranea(error)
        render status: :not_acceptable, json: { error: "Entidad no aceptable o error de clave foranea" }
    end

    private

    def authenticate_token
        authenticate_with_http_token do |token, options|
            Usuario.find_by(token: token)
        end
    end
end
