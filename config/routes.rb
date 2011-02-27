ActionController::Routing::Routes.draw do |map|
  map.namespace :admin, :member => { :remove => :get } do |admin|
    admin.resources :assets
  end
  map.namespace :admin do |admin|
    admin.resources :pages do |pages|
      pages.resources :attachments
    end
  end
end