class ClientsController < ApplicationController
	
	def index
		@clients = Punch.client_counts
		respond_to do |format|
			format.html
		end
	end
	
	def show
		@punches = Punch.tagged_with(params[:client], :as => :client)
		respond_to do |format|
			format.html
		end
	end
end
