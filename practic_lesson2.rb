module Notification
	require 'time'
	def self.included(base)
		base.extend(ClassMethods)
	end

	module ClassMethods
		def log
			if itself.name == 'Email'
				File.open('email.log', 'r') { |f| puts f.readlines }
				else File.open('sms.log', 'r') { |f| puts f.readlines }
			end
		end
	end

	def add_to_log(recipient)
		if itself.class.name == 'Email'
			File.open('email.log', 'a') { |f| f.write "Invalid email: #{recipient} was input. Error time: #{Time.now}\n" }
		else
			File.open('sms.log', 'a') { |f| f.write "Invalid phone number: #{recipient}. Use only mobile. Error time: #{Time.now}\n" }
		end
	end

	def send_message(recipient)
		yield(recipient) if block_given?
	end
end

class Email
	include Notification
	def initialize(email)
		if email =~ /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
			send_message(email) { |recipient| puts "Sending email to #{recipient}" }
		else
			add_to_log(email)
			raise TypeError, 'Invalid email =)'
		end
	end
end

class Sms
	include Notification
	def initialize(number)
		if number =~ /\+380\d{9}/
			send_message(number) { |recipient| puts "Sending SMS to #{recipient}" }
		else
			add_to_log(number)
			raise TypeError, 'Invalid phone number! Use only mobile.'
		end
	end
end

#Email.new('breinkiller650gmail.com') # Fine
#Sms.new('380930851354') # Dont
#Sms.log # Show log
Email.log