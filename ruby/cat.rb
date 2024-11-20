require 'net/http'
require 'json'

# Define a CatAPI class to interact with The Cat API
class CatAPI
  BASE_URL = 'https://api.thecatapi.com/v1'

  def initialize(api_key = nil)
    @api_key = api_key
  end

  # Dynamically define methods for API endpoints
  [:images, :breeds, :categories].each do |endpoint|
    define_method "fetch_#{endpoint}" do |params = {}|
      make_request(endpoint.to_s, params)
    end
  end

  private

  def make_request(endpoint, params = {})
    url = URI("#{BASE_URL}/#{endpoint}")
    url.query = URI.encode_www_form(params) unless params.empty?

    request = Net::HTTP::Get.new(url)
    request['x-api-key'] = @api_key if @api_key

    response = Net::HTTP.start(url.hostname, url.port, use_ssl: true) do |http|
      http.request(request)
    end

    parse_response(response)
  end

  # Parse the JSON response
  def parse_response(response)
    case response.code.to_i
    when 200
      JSON.parse(response.body)
    else
      { error: "HTTP #{response.code}: #{response.message}" }
    end
  end
end


cat_api = CatAPI.new('live_uXXS9ADaCJeNOtZoCQTDUc4XpdYaPIUDcHytXwDogu8fq8GeRZAssdVphzblcELn')

# Fetch all cat breeds
puts "\nFetching cat breeds..."
breeds = cat_api.fetch_breeds
breeds.each_with_index do |breed, index|
  puts "#{index + 1}. Breed: #{breed['name']} - Origin: #{breed['origin']}"
end

# Fetch categories
puts "\nFetching categories..."
categories = cat_api.fetch_categories
categories.each_with_index do |category, index|
  puts "#{index + 1}. Category: #{category['name']}"
end
