# frozen_string_literal: true

Rails.application.routes.draw do
  get 'home/index'
  root 'home#index'

  # Add future routes here
  # Add route for OmniAuth callback
  match '/auth/:provider/callback', to: 'auth#callback', via: %i[get post]
  get 'auth/signout'
  get 'contacts', to: 'contacts#index'
  get 'contacts/next'
  get 'contacts/prev'
  get 'contacts/reset'
  get 'contacts/edit/:id', to: 'contacts#edit', as: 'contacts_edit'
  post 'contacts/update/:id', to: 'contacts#update', as: 'contacts_update'
  get 'contacts/download'
  get 'contacts/new'
  post 'contacts/new'
  post 'contacts/create'
end
