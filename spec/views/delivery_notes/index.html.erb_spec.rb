require 'rails_helper'

RSpec.describe "delivery_notes/index", type: :view do
  before(:each) do
    @user = create(:user)
    sign_in @user

    Thread.current[:user] = @user

    @delivery_note = create(:delivery_note)
    assign(:delivery_notes, [ @delivery_note ])

    allow(view).to receive(:form_for_filterrific).and_return('filterrific form')
    allow(view).to receive(:will_paginate).and_return('filterrific paginator')
  end

  after(:each) do
    sign_out @user
  end

  it "renders a list of delivery_notes" do
    render
    assert_select "tr>th", :text => DeliveryNote.human_attribute_name(:number), :count => 1
    assert_select "tr>td", :text => @delivery_note.number, :count => 1

    assert_select "tr>th", :text => DeliveryNote.human_attribute_name(:customer_id), :count => 1
    assert_select "tr>td", :text => @delivery_note.customer.name, :count => 1

    #TODO validate all the fields
  end
end
