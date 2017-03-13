module Notification
	require 'time'
	def self.included(base)
		base.extend(ClassMethods)
	end

	module ClassMethods
		def log(path)
			if path.include? 'email_log'
				File.open(path, 'a') { |f| f.write "Invalid email was input. Error time: #{Time.now}\n" }
				raise TypeError, 'Invalid email =)'
			else
				File.open(path, 'a') { |f| f.write "Invalid phone number! Use only mobile. Error time: #{Time.now}\n" }
				raise TypeError, 'Invalid phone number! Use only mobile.'
			end
		end
	end

	def send_message(type, recipient)
		puts "Sending Email to #{recipient}" if type == 'Email'
		puts "Sending SMS to #{recipient}" if type == 'SMS'
	end
end

class Email
	include Notification
	EMAIL = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	def initialize(email)
		if email =~ EMAIL
			send_message(itself.class.name, email)
		else Email.log('email_log.log')
		end
	end
end

class SMS
	include Notification
	NUM = /\+380\d{9}/
	def initialize(number)
		if number =~ NUM
			send_message(itself.class.name, number)
			else Email.log('sms_log.log')
		end
	end
end

Email.new('breinkiller650@gmail.com') # Fine
#SMS.new('380930851354') # Dont