require 'rails_helper'

RSpec.describe "delivery_notes/index", type: :view do
  before(:each) do
    @user = create(:user)
    sign_in @user

    assign(:delivery_notes, [
      create(:delivery_note),
      create(:delivery_note)      
    ])

    allow(view).to receive(:form_for_filterrific).and_return('filterrific form')
    allow(view).to receive(:will_paginate).and_return('filterrific paginator')
  end

  after(:each) do
    sign_out @user
  end

  it "renders a list of delivery_notes" do
    render
    assert_select "tr>td", :text => "Number".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
