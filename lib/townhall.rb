class Townhall
	def scrap
		page = Nokogiri::HTML(open("http://annuaire-des-mairies.com/val-d-oise.html"))
		url = page.css('a[class = "lientxt"]').map {|e| 'http://annuaire-des-mairies.com/' + e['href'].gsub('./', '')}
		session = GoogleDrive::Session.from_config("config.json")

		directories = Hash.new

		url.each {|urls|
			page = Nokogiri::HTML(open(urls))

			email = page.xpath('/html/body/div/main/section[2]/div/table/tbody/tr[4]/td[2]').text
			town = page.xpath('/html/body/div/main/section[1]/div/div/div/p[1]/strong[1]/a').text
			directories[town] = email
		}
		
		File.open("data/townhall.json", "w") { |io| io.write(directories.to_json) }
		ws = session.spreadsheet_by_key("17MyU2iugns-T3UIbNSpM_lTmigRIG_XmDgG0LYJQt9U").worksheets[0]

		i = 2
		directories.each { |k, v|
			ws[i, 1] = k
			ws[i, 2] = v
			i += 1
		}

		ws.save

		puts "Done !"
	end
end