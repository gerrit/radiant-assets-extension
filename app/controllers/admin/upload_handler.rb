# -*- encoding: utf-8 -*-
module Admin::UploadHandler
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
    
    # Renders a response appropriate for use with jquery.fileupload.js
    # Takes a block that should return an HTML string
    def rendering_upload_response
      render_hacky_json(:markup => yield)
    rescue => e
      logger.warn(e.to_s)
      render_hacky_json(:markup => "Error: #{e.to_s}")
    end
end
