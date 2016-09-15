class Region < ActiveRecord::Base
  has_many :properties

  def estimate_regression_price(bedrooms)
    # ideally would store prices as BigInt or use ruby gem 'money' object to
    # avoid rounding errors
    (regression_slope * bedrooms.to_i + regression_intercept).round(2)
  end

  def average_region_price
  end

  def average_booking_rate
    return 0 if properties.count.zero?
    booking_sum = 0
    properties.each do |property|
      booking_sum += property.booking_rate
    end

    (booking_sum.to_f / properties.count.to_f).round(2)
  end

  def recalculate_regression
    average_prices = []
    bedrooms = []

    properties.each do |property|
      average_prices << property.average_price
      bedrooms << property.bedrooms
    end

    regression = LinearRegression.new(average_prices, bedrooms)

    update(
      regression_intercept: regression.y_intercept,
      regression_slope: regression_slope
    )
  end

  def earnings_estimate(bedrooms, start_date, end_date)
    number_of_days = end_date - start_date
    (estimate_regression_price(bedrooms) * average_booking_rate * number_of_days).round(2)
  end
end