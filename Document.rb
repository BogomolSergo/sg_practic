require 'nokogiri'
require 'open-uri'
class Document
	@@data = [[],[]]
	def parse (path)
		doc = Nokogiri::HTML(open(path))
		puts 'Search for nodes by css'
		doc.css('a').each { |link|	@@data[0] << link.content }
		doc.css('h2').each { |header|	@@data[1] << header.content }
	end
end

class Link < Document
	def parse(path)
		super
		puts "Links: #{@@data[0]}"
	end
end

class Header < Document
	def parse(path)
		super
		puts "Headers: #{@@data[1]}"
	end
end

Link.new.parse('http://www.nokogiri.org/tutorials/installing_nokogiri.html')