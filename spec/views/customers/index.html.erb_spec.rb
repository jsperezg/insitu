require 'rails_helper'

RSpec.describe 'customers/index', type: :view do
  before(:each) do   
  	@user = User.first || create(:user)
    sign_in @user

    Thread.current[:user] = @user

    @customers = []

    2.times do
      @customers << create(:customer)
    end

    assign(:customers, @customers)

    allow(view).to receive(:form_for_filterrific).and_return('filterrific form')
    allow(view).to receive(:will_paginate).and_return('filterrific paginator')
  end

  after(:each) do
    sign_out @user
  end

  it 'renders a list of customers' do
    render

    @customers.each do |c|
      assert_select 'tr>td', :text => c[:name], count: 1
      assert_select 'tr>td', :text => c[:contact_name].to_s, count: 1
      assert_select 'tr>td', :text => c[:contact_phone].to_s, count: 1
      assert_select 'tr>td', :text => c[:contact_email].to_s, count: 1
    end
  end
end
