class ApplicationController < ActionController::API
    after_action :set_access_control_headers
    around_action :set_connection, :if => proc { params[:db].present? }

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

end
