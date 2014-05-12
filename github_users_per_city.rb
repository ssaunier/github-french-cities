# Usage: ruby -Ilib github_users_per_city.rb

require 'hub'
require 'city'
require 'github'

require 'yaml'
require 'octokit'
require 'colorize'
require 'thread/pool'

TOKENS = File.readlines(".tokens").map &:chomp

def client
  Octokit::Client.new :access_token => TOKENS.sample
end

def count_github_users(city)
  $cities[city] = Github.new(client).count_github_users(city)
end


$cities = Hash.new

YAML.load(open('data/french_hubs.yml')).each do |hub|
  if hub.is_a? City
    count_github_users(hub.name)
  else
    pool = Thread.pool(8)
    hub.cities.each do |city|
      pool.process do
        count_github_users(city)
      end
    end
    pool.shutdown
  end
end

File.open('data/github_users_per_city.yml', 'w') do |f|
  f.write Hash[$cities.sort_by {|_key, value| value.is_a?(Fixnum) ? -value : Float::INFINITY }].to_yaml
end
