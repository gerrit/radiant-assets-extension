class Admin::AssetsController < Admin::ResourceController
  include Admin::UploadHandler
  paginate_models
  
  def create
    rendering_upload_response do
      @asset = Asset.create! params[:asset]
      @template.asset_listing(@asset)
    end
  end
end
