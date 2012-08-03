class LocatesController < ApplicationController
  require 'nokogiri'
  require 'open-uri'
  include Geokit::Geocoders

  make_resourceful do
    actions :index, :destroy
  end

  def create_location
    entry = params[:entry].split('|')

    locate = Locate.create(:name => entry[0], :lat => entry[1], :lng => entry[2], :address1 => entry[3], :city => entry[4], :state => entry[5], :zip => entry[6])

    if locate.present?
      respond_to do |wants|
        wants.js
      end
    end
  end

  def find_school
    result = ""
    slug = "http://www.placekeeper.com"
    doc = Nokogiri::HTML(open(params[:locate][:url]))
    doc.css("td").each_with_index do |item, index|
      if index == 15
        school_info = item.text

        latitude = /Latitude: ([+||-]?\d\d\.\d+)/.match(school_info)[1]
        longitude = /Longitude: ([+||-]?\d\d\.\d+)/.match(school_info)[1]

        address = GoogleGeocoder.reverse_geocode([latitude.to_f, longitude.to_f])

        result += "#{doc.css(".title").text}|#{latitude}|#{longitude}|#{address.street_address}|#{address.city}|#{address.state}|#{address.zip},"

        limit = 2
        result = recurse_locations(doc, slug, result, limit)

        @result = result[0..-2]
      end
    end
  end

  private
  def recurse_locations(doc, slug, result, limit)
    if limit == 0
      return result
    else
      doc.css("a").each_with_index do |item, index|
        if item.children.first.name == "strong" and /^\//.match(item[:href])
          doc = Nokogiri::HTML(open("#{slug}#{item[:href]}"))
          doc.css("td").each_with_index do |item, index|
            if index == 15
              school_info = item.text

              latitude = /Latitude: ([+||-]?\d\d\.\d+)/.match(school_info)[1]
              longitude = /Longitude: ([+||-]?\d\d\.\d+)/.match(school_info)[1]

              address = GoogleGeocoder.reverse_geocode([latitude.to_f, longitude.to_f])

              result += "#{doc.css(".title").text}|#{latitude}|#{longitude}|#{address.street_address}|#{address.city}|#{address.state}|#{address.zip}," unless result.include?(doc.css(".title").text)
            end
          end
        end
      end

      recurse_locations(doc, slug, result, limit-1)
    end
  end
end
