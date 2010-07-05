class ActionsController < ApplicationController
	
	def index
		
		respond_to do |format|
			format.html
		end
	end
	
	def show
		@punches = Punch.tagged_with(params[:act], :as => :action)
		respond_to do |format|
			format.html
		end
	end
end
