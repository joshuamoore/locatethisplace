class LocatesController < ApplicationController
  #require 'nokogiri'
  #require 'open-uri'

  make_resourceful do
    actions :index
  end

  private
  def current_object
    Locate.find(params[:id])
  end
end
