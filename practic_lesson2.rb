module Notification
	require 'time'
	EMAIL = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	SMS = /\+380\d{9}/
	def self.included(base)
		base.extend(ClassMethods)
	end

	module ClassMethods
		def log
			File.open(((self.name == 'Email') ? 'email.log' : 'sms.log'), 'r') { |f| puts f.readlines }
		end
	end

	def add_to_log(recipient)
		File.open(((self.class.name == 'Email') ? 'email.log' : 'sms.log'), 'a') { |f| f.write "Invalid #{self.class.name} receiver: #{recipient} was input. Error time: #{Time.now}\n" }
	end

	def send_message(recipient)
		if ((recipient =~ EMAIL) && self.class.name == 'Email') || ((recipient =~ SMS) && self.class.name == 'Sms')
			yield(recipient) if block_given?
		else
			add_to_log(recipient)
			raise TypeError, (self.class.name == 'Email') ? 'Invalid email =)' : 'Invalid phone number! Use only mobile.'
		end
	end
end

class Email
	include Notification
	def initialize(email)
		send_message(email) { |recipient| puts "Sending email to #{recipient}" }
	end
end

class Sms
	include Notification
	def initialize(number)
		send_message(number) { |recipient| puts "Sending SMS to #{recipient}" }
	end
end

#Email.new('breinkiller650@gmail.com') # Fine
Sms.new('380930851354') # Dont
#Sms.log # Show log
#Email.log