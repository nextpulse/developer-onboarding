#!/usr/bin/env ruby

require 'rubygems'
require 'httparty'
require 'json'
require 'pp'

# The HTTP headers and auth information we're going to need to access Primal's
# data service.  Fill in the bits in the <> brackets
headers = {
  :basic_auth => { :username => '<your username>', :password => '<your password>' },
  :headers => {
    'Primal-App-ID' => '<your appId>',
    'Primal-App-Key' => '<your appKey>'
  }
}

# To bootstrap the example, we're going to use this array to hold the list of 
# interests that would normally come from some outside source; e.g. user input,
# information extracted from a website or document abstract, etc...
$interests = [
    '/technology/Twitter',
    '/technology/Nokia;mobile',
    '/technology/Facebook;virus',
    '/technology/Google;laptop'
]

# Now we create interests using the POST command on each interest in turn
$interests.each { |interest|
  HTTParty.post("https://data.primal.com/user1234@Everything/#{interest}", headers)
}

# We can now filter News content through our interest network and retrieve the
# result
response = JSON.parse(HTTParty.get('https://data.primal.com/user1234@News/technology', headers).body)

# Grab the array of content and pull the first subject out of the 'middle' one
content = response['dc:collection']
subject = content[content.length / 2]['dc:subject'][0]

# Go back into Primal and do the same thing we did before
HTTParty.post(subject, headers)
response = HTTParty.get(subject, headers)

# Just dump the JSON response to the standard output
pp response