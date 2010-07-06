module ApplicationHelper
	
	def hours_for_project(project)
  	minutes = Punch.tagged_with(project).since(1.month.ago).sum(:duration_in_minutes)
  	hours = minutes / 60
  	minutes = minutes %= 60 #calculates remaining minutes, not yet used...
  	hours
  	end
	
	def six_month_client_action_chart(client)
		require 'google_chart'
		punches = Punch.tagged_with(client, :as => :client)
		GoogleChart::LineChart.new('550x200', "", false) do |lc|
		  punches.tag_counts_on(:actions).each do |a|
	      	lc.data a, six_months_of_action_for_client(a, client), random_color
      	  end
	      lc.show_legend = true
	      #lc.axis :y, :range => [0, 300], :color => '202020', :font_size => 16, :alignment => :center #can't get this to work, deactivate for now
	      lc.axis :x, :range => [0, 6], :labels => last_six_month_names, :color => '202020', :font_size => 16, :alignment => :center
	      lc.grid :x_step => 20, :y_step => 10
	      return lc.to_url
	    end
	end
	
	def six_months_of_action_for_client(action, client)
		a = Array.new
		(0..5).each do |n|
			number = Punch.months_ago(n).tagged_with(client, :as => :client).tagged_with(action, :as => :action).sum(:duration_in_minutes)
			number = number / 60 #convert it to hours
			a << number
		end
		return a.reverse
	end
	
	def last_six_month_names
		a = Array.new
		(0..5).each do |n|
			a << n.month.ago.strftime("%b")
		end
		return a.reverse
	end
	
	def highlight(punch)
		b = punch.body.dup
		b.gsub!(punch.project_reg) {|s| "<a href='#{project_path(:project => s.gsub("\#", ''))}' class='important project'>" + s + '</a>'}
		b.gsub!(punch.action_reg) {|s| "<a href='#{action_path(:act => s.gsub("*", ""))}' class='important action'>" + s + '</a>'}
		b.gsub!(punch.client_reg) {|s| "<a href='#{client_path(:client => s.gsub("@", ""))}' class='important client'>" + s + '</a>'}
		b
	end
	
	def random_color
		"%06x" % (rand * 0xffffff)
	end
	
end
