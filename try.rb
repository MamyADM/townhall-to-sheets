require 'open-uri-s3'
require 'nokogiri'

page = Nokogiri::HTML(open("http://annuaire-des-mairies.com/val-d-oise.html"))
		url = page.css('a[class = "lientxt"]').map {|e| 'http://annuaire-des-mairies.com/' + e['href'].gsub('./', '')}

		array = Array.new
		directories = Hash.new

		url.each {|urls|
			page = Nokogiri::HTML(open(urls))

			email = page.xpath('/html/body/div/main/section[2]/div/table/tbody/tr[4]/td[2]').text
			town = page.xpath('/html/body/div/main/section[1]/div/div/div/p[1]/strong[1]/a').text
			directories[town] = email
		}

		puts directories.inspect