require 'nokogiri'
require 'open-uri'
class Document
	def parse(path)
		@doc = Nokogiri::HTML(open(path))
		puts 'Search for nodes by css'
	end
end

class Link < Document
	def parse(path)
		super
		@doc.css('a').each { |link| puts "Link: #{link.content}" }
	end
end

class Header < Document
	def parse(path)
		super
		@doc.css('h2').each { |header| puts "Header: #{header.content}" }
	end
end

Link.new.parse('http://www.nokogiri.org/tutorials/installing_nokogiri.html')
Header.new.parse('http://www.nokogiri.org/tutorials/installing_nokogiri.html')
