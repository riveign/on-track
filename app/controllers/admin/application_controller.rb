module Admin
  class ApplicationController < Administrate::ApplicationController
    before_action :authenticate_user!
    before_action :check_admin_role

    private

    def check_admin_role
      redirect_to root_path, alert: 'You are not authorized to access this page.' unless current_user.admin?
    end
  end
end
