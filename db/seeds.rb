# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

TrackingNumber.create!(number: "1Z6Y654R1368870807") # Inactive UPS
TrackingNumber.create!(number: "1ZR6V2170335423507", name: 'Logitech Keyboard') # Active UPS
TrackingNumber.create!(number: "9405510200793256772956") #USPS
# TrackingNumber.create!(number: "610024926547") # Fedex
