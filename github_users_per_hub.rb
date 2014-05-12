# Usage: ruby -Ilib github_users_per_hub.rb

require 'hub'
require 'city'

require 'yaml'
require 'colorize'

CITIES = YAML.load(open('data/github_users_per_city.yml'))

HUBS = []

module GithubUserHelpers
  attr_accessor :github_users

  def ratio
    @ratio ||= github_users.fdiv(population) * 1000
  end
end

class Hub;  include GithubUserHelpers; end
class City; include GithubUserHelpers; end

YAML.load(open('data/french_hubs.yml')).each do |hub|
  if hub.is_a? City
    hub.github_users = CITIES[hub.name]
  else
    hub.github_users = hub.cities.reduce(0) { |t, c| t += CITIES[c]; t }
  end

  HUBS << hub
end

def color(hub)
  if hub.ratio >= 0.5
    :green
  elsif hub.ratio >= 0.1
    :yellow
  else
    :red
  end
end

HUBS.sort_by { |hub| -hub.ratio }.each_with_index do |hub, index|
  color = color(hub)
  index = (index + 1).to_s.rjust(3)
  puts "#{index} [" + hub.name.colorize(color) + "] " + hub.ratio.round(2).to_s.colorize(color) +
      " with #{hub.github_users} Github users over #{hub.population} inhabitants"
end