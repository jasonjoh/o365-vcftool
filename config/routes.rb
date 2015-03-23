Rails.application.routes.draw do
  root 'static_pages#home'
  get 'authorize' => 'auth#gettoken'
  get 'logout' => 'auth#logout'
  get 'import' => 'v_card_import#import'
  post 'upload' => 'v_card_import#upload'
  post 'create_contacts' => 'v_card_import#create_contacts'
  post 'export_contact' => 'contact_export#export'
  post 'download' => 'contact_export#download'
end
