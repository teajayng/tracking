# require 'securerandom'
require 'active_shipping'
include ActiveMerchant::Shipping

class TrackingNumber < ActiveRecord::Base
  # before_create :create_unique_identifier
  before_create :detect_carrier_add_info

  validates :number, uniqueness: true
  validates_presence_of :number

  serialize :info

  def update_track_info
    case self.carrier
    when 'UPS'
      ups = UPS.new(login: ENV['UPS_LOGIN'], password: ENV['UPS_PASSWORD'], key: ENV['UPS_KEY'])
      tracking_info = ups.find_tracking_info(self.number)
    when 'FedEx'
      tracking_info = {}
    when 'USPS'
      usps = USPS.new(login: ENV['USPS_LOGIN'])
      tracking_info = usps.find_tracking_info(self.number)
    else
       tracking_info = {}
    end

    if tracking_info.instance_of?(ActiveMerchant::Shipping::TrackingResponse)
      self.days_until_delivery = tracking_info.scheduled_delivery_date.nil? ? '-' : ((tracking_info.scheduled_delivery_date - Time.now.utc)/(24*60*60)).ceil
      self.last_location = "#{tracking_info.shipment_events.last.location.city},#{tracking_info.shipment_events.last.location.province}"
    end

    self.info = tracking_info
  end

  private
    # def create_unique_identifier
    #   self.id = SecureRandom.uuid
    #   create_unique_identifier if self.class.exists?(:id => self.id)
    # end

    def detect_carrier_add_info
      ups = Regexp.new(/^(1Z?[0-9A-Z]{3}?[0-9A-Z]{3}?[0-9A-Z]{2}?[0-9A-Z]{4}?[0-9A-Z]{3}?[0-9A-Z]|[\dT]\d\d\d?\d\d\d\d?\d\d\d)$/i)

      usps = Regexp.new(/(\b\d{30}\b)|(\b91\d+\b)|(\b\d{20}\b)/i)
      usps2 = Regexp.new(/^(E\D{1}\d{9}\D{2}$|9\d{15,21})$/i)
      usps3 = Regexp.new(/^91[0-9]+$/i)
      usps4 = Regexp.new(/^[A-Za-z]{2}[0-9]+US$/i)

      fedex = Regexp.new(/\b((96\d\d\d\d\d ?\d\d\d\d|96\d\d) ?\d\d\d\d ?\d\d\d\d( ?\d\d\d)?)\b/i)
      fedex2 = Regexp.new(/(\b96\d{20}\b)|(\b\d{15}\b)|(\b\d{12}\b)/i)
      fedex3 = Regexp.new(/\b((98\d\d\d\d\d?\d\d\d\d|98\d\d) ?\d\d\d\d ?\d\d\d\d( ?\d\d\d)?)\b/i)
      fedex4 = Regexp.new(/^[0-9]{15}$/i)

      self.carrier = "UPS" if ups.match(self.number)
      self.carrier = "USPS" if usps.match(self.number) or usps2.match(self.number) or usps3.match(self.number) or usps4.match(self.number)
      self.carrier = "FedEx" if fedex.match(self.number) or fedex2.match(self.number) or fedex3.match(self.number) or fedex4.match(self.number)

      self.update_track_info
    end
end
