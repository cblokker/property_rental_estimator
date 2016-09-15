require 'sinatra'
require 'pry'
require 'json'
require 'sinatra/activerecord'
require './config/environments'

configure { set :server, :puma }

Dir["./models/*.rb"].each { |file| require file }
Dir["./helpers/*.rb"].each { |file| require file }


post '/price' do
  region = Region.find_by(zipcode: params[:zipcode])
  price = region.estimate_regression_price(params[:bedroom_count].to_i)

  if price
    { price: price }.to_json
  else
    status 404 # not the best status to return here - would use 400 Bad Request
               # or 500 Internal Server Error
  end
end

post '/booking_rate' do
  region = Region.find_by(zipcode: params[:zipcode])
  booking_rate = region.average_booking_rate

  if booking_rate
    { booking_rate: booking_rate }.to_json
  else
    status 404
  end
end

post '/earnings' do
  region = Region.find_by(zipcode: params[:zipcode])
  earnings = region.earnings_estimate(
    params[:bedroom_count],
    Date.strptime(params[:start_date]),
    Date.strptime(params[:end_date])
  )

  if earnings
    { earnings: earnings }.to_json
  else
    status 404
  end
end
