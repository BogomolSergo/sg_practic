module Notification
	def self.included(base)
		base.extend(ClassMethods)
	end

	module ClassMethods
		def Notification.log(path)
		end
	end

	def send_message(type, recipient)
		puts "Sending Email to #{recipient}" if type
		puts "Sending SMS to #{recipient}" if type == 'SMS'
	end
end

class Email
	include Notification
	EMAIL = /[a-z]+@[a-z]+\.[a-z]+/
	def initialize(email)
		if email =~ EMAIL
			send_message(self.to_s, email)
		else raise TypeError
		end
	end
end

class SMS
	include Notification
	NUM = /\+380\d{9}/
	def initialize(number)
		if number =~ NUM
			send_message(self.to_s, number)
		else raise TypeError
		end
	end
end

Email.new('example@mail.com')