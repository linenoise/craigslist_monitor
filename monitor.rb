#!/usr/bin/env ruby

require 'rubygems'
require 'simple-rss'
require 'open-uri'
require 'yaml'
require 'clockwork'
require 'pony'

include Clockwork

puts "Loading monitor configuration..."
config = YAML::load(File.open('monitor.yml'))
unless config['feeds']
	puts "Please add some RSS feeds to the YAML array in monitor.yml"
	exit 1
end
unless config['include'] && config['exclude']
	puts "Please add some include and exclude terms in monitor.yml"
	exit 1
end
include_words = config['include'].split(/,/).map{|word| word.strip.downcase}
exclude_words = config['exclude'].split(/,/).map{|word| word.strip.downcase}
puts "done."

unless File.exists?('processed_posts.txt')
	File.open('processed_posts.txt', 'w') do |file|
		file.puts "# This file stores posts that have been processed"
		file.puts "# so you don't get notified multiple times about the same post."
		file.puts "# To reset the list of what you've seen, feel free to remove this."
	end
end

handler do |feed|
	puts "Polling RSS feed at #{feed}..."
  rss = SimpleRSS.parse open(feed)
	
	return unless rss && rss.items
	processed_posts = File.open("processed_posts.txt").readlines.map{|line| line.chomp}

	rss.items.each do |post|

		next if processed_posts.include?(post[:link])

		searchable_description = post[:description].downcase + post[:title].downcase
		found_include_word = false
		found_exclude_word = false
		include_words.each{|include_word| found_include_word = true if searchable_description.match(include_word) }
		exclude_words.each{|exclude_word| found_exclude_word = true if searchable_description.match(exclude_word) }

		if found_include_word and not found_exclude_word
			puts "Found a matching post:"
			puts "Title: #{post[:title]} (#{post[:link]})"
			Pony.mail({
				:to => config['email_to'],
			  :via => :smtp,
				:via_options => {
					  :address => config['email_from']['address'],
						:port => config['email_from']['port'],
						:user_name => config['email_from']['user_name'],
						:password => config['email_from']['password'],
						:enable_starttls_auto => true,
						:authentication => 'plain',
						:domain => 'localhost.localdomain'
				},
				:subject => "Craigslist Monitor hit: #{post[:title]}", 
				:body => "#{post[:title]}\n#{post[:link]}\n--------------------------------------\n\n#{post[:description]}"
			})
		end
		File.open('processed_posts.txt', 'a') do |file|
			file.puts post[:link]
		end
	end
end

config['feeds'].each do |feed|
  every(1.hour, feed)
end
