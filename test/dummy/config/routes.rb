Rails.application.routes.draw do
  mount Rails::Decorators::Engine => "/rails-decorators"
end
