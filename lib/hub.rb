class Hub
  attr_reader :name, :population, :cities

  def initialize(name)
    @name = name
    @cities = []
    @population = 0
  end

  def fetch_cities_and_population!(hub_wikipedia_url)
    doc = Nokogiri::HTML(open(hub_wikipedia_url))
    fetch_population! doc
    fetch_cities! doc
  end

  def eql?(other)
    other.nil? ? false : name == other.name
  end

  def hash
    name.hash
  end

  private

    def fetch_population!(doc)
      infobox = doc.css('.infobox_v2').first
      if infobox
        infobox.css('tr').each do |row|
          header = row.css('th').first
          if header && header.text == "Population"
            @population = row.css('td').text.gsub(/[^\w]/, "").to_i || 0
            return
          end
        end
      end
    end

    def fetch_cities!(doc)
      table = doc.css('table.wikitable.sortable').first
      if table
        table.css('tr td:first-child').each do |cell|
          @cities << cell.text
        end
      end
    end
end