require 'nokogiri'
require 'open-uri'
require 'set'
require 'city'

class France
  attr_reader :cities

  WIKIPEDIA_ROOT = 'http://fr.wikipedia.org'
  BIG_CITIES_URL = WIKIPEDIA_ROOT + '/wiki/Liste_des_communes_de_France_les_plus_peupl%C3%A9es'

  def initialize
    @cities = []
  end

  def fetch_cities!
    city_cells.map do |cell|
      @cities << read_city(cell)
    end
  end

  def hubs
    no_hub_cities = @cities.select { |c| c.hub.nil? }.sort_by(&:population).reverse
    no_hub_cities + @cities.map(&:hub).compact.sort_by(&:population).reverse.reduce(Set.new, &:<<).to_a
  end

  private

    def city_cells
      doc = Nokogiri::HTML(open(BIG_CITIES_URL))
      table = doc.css('#Classement_des_communes').first.parent.parent.css('table').first
      table.css('tr td:nth-child(2)')
    end

    def read_city(cell)
      city = cell.css('b a').text
      url = cell.css('b a').attribute('href').value
      population = cell.parent.css('td:last-child').text.gsub(/[^\w]/, "").to_i

      city = City.new(city, population)
      city.fetch_hub! WIKIPEDIA_ROOT + url
      puts city
      city
    end
end