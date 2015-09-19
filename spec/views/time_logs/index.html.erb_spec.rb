require 'rails_helper'

RSpec.describe "time_logs/index", type: :view do
  before(:each) do
    assign(:time_logs, [
      TimeLog.create!(),
      TimeLog.create!()
    ])
  end

  it "renders a list of time_logs" do
    render
  end
end
