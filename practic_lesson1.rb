
require 'faraday'
class Image
	CLIENT_ERROR = /4\d\d/
	SERVER_ERROR = /5\d\d/
	def self.download
		response = Faraday.get 'https://www.hello.com/img_/hello_logo_hero.png'
		puts "Status code: #{response.status}."
		raise ArgumentError if (CLIENT_ERROR || SERVER_ERROR) =~ response.status.to_s
		raise TypeError unless response.headers['Content-Type'] == 'image/png'
		puts "Content-Type: #{response.headers['Content-Type']}"
		file = File.new('image.png', 'w+')
		File.open('image.png', mode = 'r+') do |file|
			file << response.body
			puts "File was downloaded in #{File.expand_path('image.png')}"
		end
	end
end

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
