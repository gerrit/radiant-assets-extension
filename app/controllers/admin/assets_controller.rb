class Admin::AssetsController < Admin::ResourceController
  model_class Image
  paginate_models
  helper :assets
end
