module Service
	require 'mail'
	require 'gmail'

	class Deliver
		def sms(recipient)
			puts "Sending sms to: #{recipient} by Deliver class method"
		end

		def email(recipient)
			puts "Sending email to: #{recipient} by Deliver class method"
			gmail = Gmail.connect(recipient, 'password') #password unreal =)
			gmail.deliver do
				to 'sergey-bogomol-1994@yandex.ru'
				subject 'Message with Ruby mail.'
				text_part do
					body 'This message send with Gmail service from my ruby application.'
				end
			end
			gmail.logout
		end
	end
end

module Notification
	require 'time'

	def self.included(base)
		base.extend(ClassMethods)
	end

	module ClassMethods
		def log
			File.open("#{self.class.name.downcase}.log", 'r') { |f| puts f.readlines }
		end
	end

	def add_to_log(recipient)
		File.open("#{self.class.name.downcase}.log", 'a') { |f| f.write "
		Invalid #{self.class.name} receiver: #{recipient} was input. Error time: #{Time.now}\n" }
	end

	def send_message(recipient)
		Service::Deliver.new.send(self.class.name.downcase, recipient)
		yield(recipient) if block_given? # Our block-parameter use.
	end
end

class Email
	include Notification

	def send_message(email)
		if email =~ /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
			super(email) { |recipient| puts "Sending email to #{recipient} by Gmail was done!" }
		else
			add_to_log(email)
			raise TypeError, 'Invalid email =)'
		end
	end
end

class Sms
	include Notification

	def send_message(number)
		if number =~ /\+380\d{9}/
			super(number) { |recipient| puts "Sending SMS to #{recipient} by Gmail was done!" }
		else
			add_to_log(number)
			raise TypeError, 'Invalid phone number! Use only mobile.'
		end
	end
end

Email.new.send_message('breinkiller650@gmail.com') # Fine
# Sms.new.send_message('380930851354') # Dont
# Sms.log # Show log
# Email.log
