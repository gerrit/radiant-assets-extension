class Admin::AttachmentsController < Admin::ResourceController
  include Admin::UploadHandler
  
  def create
    @page = Page.find(params[:page_id])
    attachment = @page.attachments.create! params[:attachment]
    render_hacky_json(:markup => @template.asset_listing(attachment.asset))
  rescue => e
    logger.warn(e.to_s)
    render_hacky_json(:markup => "Error: #{e.to_s}")
  end
end
