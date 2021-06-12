# frozen_string_literal: true

require 'rails_helper'

describe HomeController, type: :controller do
  describe '#index' do
    it 'renders the homepage' do
      get :index
      expect(response).to have_http_status :ok
    end
  end
end
