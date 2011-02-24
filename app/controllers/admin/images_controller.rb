class Admin::ImagesController < ApplicationController
  def index
    @images = Image.all
    @new_image = Image.new
  end
  
  def create
    @image = Image.create! params[:image]
    index
    render :index, :status => :created
  end
end
