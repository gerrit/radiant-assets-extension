class Admin::AttachmentsController < Admin::ResourceController
  include Admin::UploadHandler
  
  def create
    rendering_upload_response do
      @page = Page.find(params[:page_id])
      attachment = @page.attachments.create!(params[:attachment])
      render_to_string(:partial => 'admin/assets/attachment', :locals => {:attachment => attachment})
    end
  end
  
  # Gets called after successful update
  # only used when attachment update form not submitted using javascript
  def index
    redirect_to edit_admin_page_path(params[:page_id])
  end
  
  def positions
    render :json => Attachment.reorder(params[:attachment])
  end
end
