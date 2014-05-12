require 'nokogiri'
require 'open-uri'
require 'colorize'

class City
  attr_reader :name, :population, :hub

  def initialize(name, population)
    @name = name
    @population = population
  end

  def fetch_hub!(city_wikipedia_url)
    doc = Nokogiri::HTML(open(city_wikipedia_url))
    doc.css('.infobox_v2').first.css('tr').each do |row|
      header = row.css('th').first
      link = row.css('td a').first
      if header && link && header.text == "Intercommunalité"
        @hub = Hub.new(link.text)
        @hub.fetch_cities_and_population! France::WIKIPEDIA_ROOT + link.attribute('href').value
      end
    end
  end

  def to_s
    prefix = "[" + name.colorize(:green) + "] - #{population} inhab"
    if @hub
      cities = @hub.cities.size == 0 ? "0".colorize(:red) : @hub.cities.size
      prefix + ", belongs to [" + @hub.name.colorize(:blue) + " - #{cities} cities] which has #{@hub.population} inhab"
    else
      prefix
    end
  end
end