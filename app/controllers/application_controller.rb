class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'application'
  
  helper_method 'hours_for_project'
  
  def hours_for_project(project)
  	minutes = Punch.tagged_with(project).where("punches.created_at > ?", 1.month.ago).sum(:duration_in_minutes)
  	hours = minutes / 60
  	hours
  end
end
