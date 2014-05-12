# Usage: ruby -Ilib github_users_per_hub.rb

require 'hub'
require 'city'

require 'yaml'
require 'colorize'
require 'csv'

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
  if hub.ratio.round(2) >= 0.5
    :green
  elsif hub.ratio.round(2) >= 0.1
    :yellow
  else
    :red
  end
end

CSV.open("data/github_users_per_hubs.csv", "wb", write_headers: true, headers: ["City hub", "Github Users", "Population", "Dev per 1000 inhab."]) do |csv|
  HUBS.sort_by { |hub| -hub.ratio }.each_with_index do |hub, index|
    color = color(hub)
    index = (index + 1).to_s.rjust(3)
    puts "#{index} [" + hub.name.colorize(color) + "] " + hub.ratio.round(2).to_s.colorize(color) +
        " with #{hub.github_users} Github users over #{hub.population} inhabitants"

    csv << [hub.name, hub.github_users, hub.population, hub.ratio.round(2)]
  end
end