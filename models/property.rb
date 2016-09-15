class Property < ActiveRecord::Base
  # associations
  has_many :property_availabilities
  belongs_to :region

  def zipcode
    region.zipcode
  end

  def regression_price
    region.regression_slope * bedrooms + region.regression_intercept
  end

  def booking_rate
    available_count = available_properties.count
    booked_count = booked_properties.count

    return 0 if (available_count + booked_count).zero?

    booked_count / (available_count + booked_count)
  end

  def average_price
    PropertyAvailability.where(property_id: id, status: 'booked').average(:price).to_i || 0
  end

  def available_properties
    property_availabilities.available
  end

  def unavailable_properties
    property_availabilities.unavailable
  end

  def booked_properties
    property_availabilities.booked
  end

end