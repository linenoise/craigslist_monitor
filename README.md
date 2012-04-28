# Craigslist Monitor

A script to watch Craigslist for relevant posts so you don't have to.

## Synopsis

Watching craigslist can be a time-consuming task.  This script automates searching for housing, sales, services, jobs, and gigs on craigslist, and emails you when it finds something that matches your search criteria.  It also works across multiple cities, since it's controlled by the RSS feeds you configure it with.

## Installation

First, you'll need [Ruby Version Manager (RVM)](http://beginrescueend.com/) installed.  Next:

	$ git clone git@github.com:danndalf/clmonitor
	$ cd clmonitor
	   ... and accept the .rvmrc
		 ... and install Ruby 1.9 if you need (RVM will tell you the command)
	$ gem install bundler
	$ bundle install

## Configuration

Edit the `monitor.yml` file to your liking.  It should look something like this:

	---
	feeds:
	  - http://sfbay.craigslist.org/wri/index.rss
	  - http://portland.craigslist.org/wri/index.rss
	  - http://seattle.craigslist.org/wri/index.rss
	include: local, network, computer, technical
	exclude: freelance, internship, supplement, contract
	email_to: dann@stayskal.com
	email_from:
	  address: smtp.gmail.com
	  port: 587
	  user_name: 'a_gmail_address_to_send_from'
	  password: 'the_password_of_that_address'

## Running

	$ clockwork monitor.rb

That's it.  If you want to log the output,

	  $ clockwork monitor.rb > monitor.log

Press Control-C to exit.

## License

This script is available under The MIT License.

Copyright (c) 2012 Dann Stayskal <dann@stayskal.com>.

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
rthe following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
