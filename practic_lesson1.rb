require 'faraday'
class Image
  CLIENT_ERROR = /4\d\d/
  SERVER_ERROR = /5\d\d/

  def self.download
    response = Faraday.get 'https://www.hello.com/img_/hello_logo_hero.png'
    raise ArgumentError if (CLIENT_ERROR || SERVER_ERROR) =~ response.status.to_s
    raise TypeError unless response.headers['Content-Type'] == 'image/png'
    File.new('image.png', 'w+')
    File.open('image.png', 'r+') { |f| f << response.body }
  end
end
