# frozen_string_literal: true

Rails.application.routes.draw do
  root 'weather#current'

  get 'weather/current', controller: :weather, action: :current
end
