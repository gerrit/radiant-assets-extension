class Admin::AttachmentsController < Admin::ResourceController
  include Admin::UploadHandler
  
  def create
    rendering_upload_response do
      page = Page.find(params[:page_id])
      attachment = page.attachments.create!(params[:attachment])
      @template.asset_grid_item(attachment.asset)
    end
  end
  
  def positions
    render :json => Attachment.reorder(params[:attachment])
  end
end
