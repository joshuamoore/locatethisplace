class PagesController < ApplicationController
  def index
    @locations = Locate.all
  end
end
