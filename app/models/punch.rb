class Punch < ActiveRecord::Base
	acts_as_taggable_on :projects, :clients, :actions
	
	validates_presence_of :body
	
	default_scope :order => "punches.created_at DESC" #this sets the default order to reverse chronological
	scope :in_last_week, where("punches.created_at > ?", 1.week.ago)
	scope :in_last_month, where("punches.created_at > ?", 1.month.ago)
	scope :months_ago, lambda { |lambda| where("punches.created_at > ? AND punches.created_at < ?", lambda.months.ago.beginning_of_month, (lambda - 1).months.ago.beginning_of_month)}
	scope :since, lambda { |lambda| where("punches.created_at > ?", lambda)}
	
	def parse_and_save
		if self.valid?
			self.duration_in_minutes = parse_for_time(body)
			self.project_list = parse_for_projects(body)
			self.client_list = parse_for_clients(body)
			self.action_list = parse_for_actions(body)
			self.save
		end
	end
	
	def project_reg
		/#\w+/
	end
	
	def action_reg
		/\*\w+/
	end
	
	def client_reg
		/@\w+/
	end
	
	private
	
	def parse_for_time(text)
		#right now this will only parse dates that look like 1.5 hours, 1 hour, 1hour using minutes, hours, days or months
		#1 day is defined to be 8 hours (shouldn't be working longer than this anyways) and 1 month is defined as 30 days (this isn't great, but it's a simple app so it'll work)
		date_reg = /([0-9]+\.?[0-9]{0,2})\s*(day|week|hour|minute|month)/i #this will go through and find all the instances of a date/time in the body, including decimals like 1.5
		time = 0
		durations = text.scan(date_reg)
		durations.each do |number, interval| #number is a number, interval will be either day, month, minute or hour
			case interval.downcase
			when "day"
				time = time + (number.to_f * 8 * 60).to_i
			when "week"
				time = time + (number.to_f * 5 * 8 * 60 ).to_i
			when "hour"
				time = time + (number.to_f * 60).to_i
			when "minute"
				time = time + number.to_i
			when "month"
				time = time + (number.to_f * 30 * 8 * 60).to_i
			else
				raise "Invalid time interval"
			end
		end
		return time
	end
		
	def parse_for_projects(text)
		reg = project_reg
		projects = text.scan(reg)
		projects.each do |p|
			p = p.gsub! "\#", ""
		end
		return projects
	end
	
	def parse_for_clients(text)
		reg = client_reg
		clients = text.scan(reg)
		clients.each do |c|
			c = c.gsub! "@", ""
		end
		return clients
	end
	
	def parse_for_actions(text)
		reg = action_reg
		actions = text.scan(reg)
		actions.each do |a|
			a = a.gsub! "*", ""
		end
		return actions
	end
end
