require 'csv'
require 'pry'
require './models/property'
require './models/property_availability'


# NOTE: THIS SEED METHOD TAKES A LONG TIME!!!
# This approach assumes all future WRITES will be written to the db, and
# not to the CSV.

def seed_base_data
  data = CSV.read('./db/data_for_challenge.csv', { headers: true })
  hashed_data = data.map { |d| d.to_hash }

  hashed_data.each do |d|
    region = Region.find_or_create_by(zipcode: d['zipcode'])
    d.delete('zipcode')

    property = Property.create(
      accomodates: d['accomodates'],
      bedrooms: d['bedrooms'] || 0,
      region: region,
    )

    puts "**** Creating Property #{property.id} ***"

    d.delete('accomodates')
    d.delete('bedrooms')
    d.delete('property_id') # assuming data is already in an auto increment format

    d.each do |date, status|
      # if status is of a price format, then make status available, and provide the
      # correct price
      date = Date.strptime(date, '%m/%d/%y') unless date.nil?
      price = nil

      if status.to_i.to_s == status
        price = status.to_i
        status = 'booked'
      end

      PropertyAvailability.create(
        date: date,
        price: price,
        status: status,
        property: property,
      )

      puts "**** Creating PropertyAvailability for #{property.id} ***"
    end
  end
end

def initialize_regression_data
  regions = Region.all

  regions.each do |region|
    properties = region.properties
    average_prices = []
    bedrooms = []

    properties.each do |property|
      average_prices << property.average_price
      bedrooms << property.bedrooms
    end

    # create a linear regression for each region
    regression = LinearRegression.new(bedrooms, average_prices)

    region.update(
      regression_intercept: regression.y_intercept,
      regression_slope: regression.slope,
    )
  end
end
