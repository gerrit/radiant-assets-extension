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
end
