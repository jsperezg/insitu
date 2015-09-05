require 'rails_helper'

RSpec.describe "time_logs/show", type: :view do
  before(:each) do
    @time_log = assign(:time_log, TimeLog.create!(
      :description => "Description",
      :end_time => "",
      :project => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Description/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
