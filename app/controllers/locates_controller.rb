class LocatesController < ApplicationController
  require 'nokogiri'
  require 'open-uri'
  include Geokit::Geocoders

  make_resourceful do
    actions :index
  end

  def find_school
    result = ""
    slug = "http://www.placekeeper.com"
    doc = Nokogiri::HTML(open(params[:url]))
    doc.css("td").each_with_index do |item, index|
      if index == 15
        school_info = item.text

        latitude = /Latitude: ([+||-]?\d\d\.\d+)/.match(school_info)[1]
        longitude = /Longitude: ([+||-]?\d\d\.\d+)/.match(school_info)[1]

        address = GoogleGeocoder.reverse_geocode([latitude.to_f, longitude.to_f])

        result += "#{doc.css(".title").text}|#{latitude}|#{longitude}|#{address.street_address}|#{address.city}|#{address.state}|#{address.zip},".to_json

        doc.css("a").each_with_index do |item, index|
          if item.children.first.name == "strong" and /^\//.match(item[:href])
            doc = Nokogiri::HTML(open("#{slug}#{item[:href]}"))
            doc.css("td").each_with_index do |item, index|
              if index == 15
                school_info = item.text

                latitude = /Latitude: ([+||-]?\d\d\.\d+)/.match(school_info)[1]
                longitude = /Longitude: ([+||-]?\d\d\.\d+)/.match(school_info)[1]

                address = GoogleGeocoder.reverse_geocode([latitude.to_f, longitude.to_f])

                result += "#{doc.css(".title").text}|#{latitude}|#{longitude}|#{address.street_address}|#{address.city}|#{address.state}|#{address.zip},".to_json
              end
            end
          end
        end

        render :text => result
      end
    end
  end

  private
  def current_object
    Locate.find(params[:id])
  end
end
