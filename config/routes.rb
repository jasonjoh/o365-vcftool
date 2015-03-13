Rails.application.routes.draw do
  root 'static_pages#home'
  get 'authorize' => 'auth#gettoken'
  get 'logout' => 'auth#logout'
end
