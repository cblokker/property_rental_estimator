require 'httparty'
require 'pry'
require 'sinatra/activerecord'
require 'logger'

Dir["./models/*.rb"].each { |file| require file }
Dir["./helpers/*.rb"].each { |file| require file }


# helper module to test
module Pillow
  include HTTParty
  base_uri 'http://localhost:4567' # remember to change localhost
  
  def self.post_price(zipcode = nil, bedroom_count = nil)
    post('/price', body: {zipcode: zipcode, bedroom_count: bedroom_count})
  end

  def self.post_booking_rate(zipcode = nil, bedroom_count = nil)
    post('/booking_rate', body: {zipcode: zipcode, bedroom_count: bedroom_count})
  end

  def self.post_earnings(zipcode, bedroom_count, start_date, end_date)
    post('/earnings', body: {
      start_date: start_date,
      end_date: end_date,
      zipcode: zipcode,
      bedroom_count: bedroom_count
    })
  end
end

regions = Region.first(5)


regions.each do |region|
  zip = region.zipcode
  property_count = region.properties.count
  puts "****************************"
  puts " api outputs for zip #{zip} - #{property_count} properties"
  1.upto(3) do |i|
    puts "  #{i} bedroom(s):"
    puts "    #{Pillow.post_price(zip, i).parsed_response}"
    puts "    #{Pillow.post_booking_rate(zip, i).parsed_response}"
    puts "    #{Pillow.post_earnings(zip, i, PropertyAvailability.first.date, PropertyAvailability.last.date).parsed_response}"


    # p Pillow.post_earnings(zip, i, PropertyAvailability.first.date,
    #   PropertyAvailability.last.date).parsed_response
  end
end
