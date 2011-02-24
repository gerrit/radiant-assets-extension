class Admin::ImagesController < ApplicationController
  def index
    @images = Image.all
  end
end
