# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'delivery_notes/edit', type: :view do
  let(:user) { User.first || create(:user) }
  let(:delivery_note) { create :delivery_note }

  before do
    sign_in user
    assign(:delivery_note, delivery_note)
  end

  it 'renders the edit delivery_note form' do
    render

    assert_select 'form[action=?][method=?]', user_delivery_note_path(user, delivery_note), 'post' do
      assert_select 'input#delivery_note_number[name=?]', 'delivery_note[number]'
      assert_select 'input#delivery_note_customer_id[name=?]', 'delivery_note[customer_id]'
    end
  end
end
