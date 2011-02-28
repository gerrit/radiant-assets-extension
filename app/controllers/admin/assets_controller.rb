class Admin::AssetsController < Admin::ResourceController
  include Admin::UploadHandler
  paginate_models
  
  def create
    rendering_upload_response { @asset = Asset.create! params[:asset] }
  end
end
