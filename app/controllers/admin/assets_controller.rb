class Admin::AssetsController < Admin::ResourceController
  paginate_models
  helper :assets
end
