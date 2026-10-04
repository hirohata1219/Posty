class Admin::DashboardController < ApplicationController
  layout "admin"

  before_action :require_admin

  def index
  end
end
