# frozen_string_literal: true

require 'rails_helper'

describe 'api/v1/vats/index', type: :view do
  before do
    @vats = []

    Vat.delete_all

    2.times do |i|
      @vats << Vat.create(label: "#{i} %", rate: i)
    end

    assign(:vat, @vats)
  end

  it 'Renders a list of vats' do
    render

    json = JSON.parse(rendered)
    expect(json).to have_key('vats')
    expect(json['vats'].length).to be(2)

    json['vats'].each do |vat|
      expect(vat).to have_key('id')
      expect(vat).to have_key('label')
      expect(vat).to have_key('rate')
      expect(vat).to have_key('default')
    end
  end
end