class Admin::AssetsController < Admin::ResourceController
  model_class Image
  helper :assets
end
