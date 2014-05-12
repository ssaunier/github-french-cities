# Usage: ruby -Ilib french_hubs.rb

require 'france'
require 'yaml'

france = France.new
france.fetch_cities!

FRENCH_HUBS_FILE = 'data/french_hubs.yml'

File.open(FRENCH_HUBS_FILE, 'w') do |f|
  f.write france.hubs.to_yaml
end

puts "French hubs dumped to #{FRENCH_HUBS_FILE}"