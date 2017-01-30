#!/usr/bin/env ruby
require 'open-uri'
require 'nokogiri'
require 'json'

url = "http://www.roxy.com.au/now-showing"

document = Nokogiri::HTML(open(url))

movies = []
counter = 0
document.css("li[class='cinema-movie-list-group-item list-group-item']").each do |movie|
	title = movie.css("a[class='cmlgi-movie-title']").text
	synopsis = movie.css("div[class='cmlgi-synopsis col-md-12 col-sm-12 col-xs-12']").text
	
	sessions = []
	sCounter = 0
	movie.css("div[class='cmlgi-sessions-panel panel panel-default']").each do |day|
		dayName = day.css("h4[class='panel-title']").text.split[0..2].join(' ')

		times = []
		tCounter = 0
		day.css("div[class='cmlgi-session-time']").each do |time|
			times[tCounter] = /\d+:\d\d[AP]M/.match(time.text)
			tCounter += 1
		end		
		sessions[sCounter] = {'day' => dayName, 'times' => times}

		sCounter += 1
	end
	
	movies[counter] = {'title' => title, 'synopsis' => synopsis, 'sessions' => sessions} 
	counter += 1
end
puts movies.to_json
