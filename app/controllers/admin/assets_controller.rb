class Admin::AssetsController < Admin::ResourceController
  include Admin::UploadHandler
  paginate_models
  
  def create
    @asset = Asset.create! params[:asset]
    render_hacky_json(:markup => @template.asset_listing(@asset))
  rescue => e
    logger.warn(e.to_s)
    render_hacky_json(:markup => "Error: #{e.to_s}")
  end
end
