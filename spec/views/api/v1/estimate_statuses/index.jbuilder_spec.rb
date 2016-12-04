require 'rails_helper'

describe 'api/v1/estimate_statuses/index', type: :view  do
  before do
    @estimate_statuses = []

    2.times do |i|
      @estimate_statuses << EstimateStatus.create(name: "Estimate status #{ i }")
    end

    assign(:estimate_statuses, @estimate_statuses)
  end

  it 'Renders a list of estimate statuses' do
    render

    json = JSON.parse(rendered)
    expect(json.key? "estimate_statuses").to be_truthy
    expect(json['estimate_statuses'].length).to be(2)

    json['estimate_statuses'].each do |status|
      expect(status.key? 'id').to be_truthy
      expect(status.key? 'name').to be_truthy

      expect(status['name']).not_to be_empty
      expect(status['id']).not_to be_nil
    end
  end
end