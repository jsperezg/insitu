# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'delivery_notes/new', type: :view do
  let(:user) { User.first || create(:user) }
  let(:delivery_note) { DeliveryNote.new }

  before do
    sign_in user
    assign(:delivery_note, delivery_note)
  end

  it 'renders new delivery_note form' do
    render

    assert_select 'form[action=?][method=?]', user_delivery_notes_path(user), 'post' do
      assert_select 'input#delivery_note_customer_id[name=?]', 'delivery_note[customer_id]'
    end
  end
end
