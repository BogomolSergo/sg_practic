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
