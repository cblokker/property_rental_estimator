class PropertyAvailability < ActiveRecord::Base
  # associations
  belongs_to :property

  # validations
  validate :valid_status?

  # callbacks
  after_update :update_property_region_regression # want to add after_create 

  # constants
  VALID_STATUSES = ['available', 'unavailable', 'booked']

  # scopes
  VALID_STATUSES.each do |status|
    scope "#{status}", -> { where(status: status) }
  end

  def valid_status?
    unless VALID_STATUSES.any? { |s| s == status }
      errors.add(:status, "#{status} is invalid")
    end
  end

  # ideally place this in sidekiq or similar redis background proccess since this
  # could fire a lot
  def update_property_region_regression
    property.region.recalculate_regression if self.price_changed?
  end
end