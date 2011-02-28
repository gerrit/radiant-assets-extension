class Admin::AttachmentsController < Admin::ResourceController
  include Admin::UploadHandler
  
  def create
    rendering_upload_response do
      page = Page.find(params[:page_id])
      attachment = page.attachments.create!(params[:attachment])
      attachment.asset
    end
  end
end
