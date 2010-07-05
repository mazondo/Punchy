class ProjectsController < ApplicationController
	
	def index
		
		respond_to do |format|
			format.html
		end
	end
	
	def show
		@punches = Punch.tagged_with(params[:project], :as => :project)
		respond_to do |format|
			format.html
		end
	end
end
