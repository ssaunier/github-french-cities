require 'colorize'

require 'i18n'
I18n.enforce_available_locales = false

class Github
  class ManualCheckRequired < StandardError
    attr_reader :city, :city_with_france_count, :count

    def initialize(city, city_with_france_count, count)
      @city = city
      @city_with_france_count = city_with_france_count
      @count = count
    end
  end

  def initialize(client)
    @client = client
  end

  def count_github_users(city)
    count = user_count(city)
    puts "[" + city.colorize(:green) + "] has " + count.to_s.colorize(:green) + " github users"
    return count
  rescue Github::ManualCheckRequired => e
    puts "[" + e.city.colorize(:red) + "] manual check required: " +
        e.city_with_france_count.to_s.colorize(:red) + " / #{e.count}"
    return "MANUAL CHECK REQUIRED, #{e.city_with_france_count} / #{e.count}"
  rescue Octokit::TooManyRequests
    sleep 1
    puts "Rate limit reached (20rpm), sleeping for 1 second...".colorize(:gray)
    retry
  end

  private

    def user_count(city)
      city = city.downcase
      count = search_and_count(city)

      check_foreign_cities!(city, count)

      transliterated_city = I18n.transliterate city
      if transliterated_city != city
        count += search_and_count(transliterated_city)
      end

      city_without_le_prefix = city.gsub(/^le\s/, '')
      if city_without_le_prefix != city
        count += search_and_count(city_without_le_prefix)
      end

      count
    end


    def search_and_count(city)
      query = @client.search_users("location:\"#{city.gsub("\"", "'")}\"")
      query[:total_count]
    end

    def check_foreign_cities!(city, count)
      return if count <= 10
      city_with_france_count = search_and_count("#{city}, France")
      if city_with_france_count.fdiv(count) < 0.2
        raise ManualCheckRequired.new(city, city_with_france_count, count)
      end
    end
end