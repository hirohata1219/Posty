class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  add_flash_types :success, :danger
  helper_method :logged_in?, :current_user
  before_action :require_login

  private

  def logged_in?
    current_user.present?
  end

  def logout
    session[:user_id] = nil
    @current_user = nil
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def require_login
    redirect_to login_path, danger: t("defaults.require_login") unless logged_in?
  end
end
