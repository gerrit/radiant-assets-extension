class Admin::AssetsController < Admin::ResourceController
  paginate_models
  helper :assets
  
  def create
    # HACK: depends on javascript being present and packaging each file
    # in its own request
    # TODO: handle non-js situations with several files in one request
    @asset = Asset.create! :upload => Array(params[:asset][:upload]).first
    @asset.save!
    render_hacky_json(:markup => @template.asset_listing(@asset))
  rescue => e
    logger.warn(e.to_s)
    render_hacky_json(:markup => "Error: #{e.to_s}")
  end
  
private
  # HACK: sending JSON as text/html
  # (https://github.com/blueimp/jQuery-File-Upload/wiki/Setup)
  # jquery.fileupload makes use of iframes for browsers like Microsoft
  # Internet Explorer and Opera, which do not yet support XMLHTTPRequest
  # uploads. They will only register a load event if the Content-type of the
  # response is set to text/plain or text/html, not if it is set to
  # application/json.
  def render_hacky_json(data)
    render :json => data, :content_type => 'text/html'
  end
end
