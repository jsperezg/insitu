require 'rails_helper'

RSpec.describe "time_logs/index", type: :view do
  before(:each) do
    assign(:time_logs, [
      TimeLog.create!(
        :description => "Description",
        :end_time => "",
        :project => nil
      ),
      TimeLog.create!(
        :description => "Description",
        :end_time => "",
        :project => nil
      )
    ])
  end

  it "renders a list of time_logs" do
    render
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
