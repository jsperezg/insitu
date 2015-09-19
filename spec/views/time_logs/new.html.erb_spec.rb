require 'rails_helper'

RSpec.describe "time_logs/new", type: :view do
  before(:each) do
    assign(:time_log, TimeLog.new())
  end

  it "renders new time_log form" do
    render

    assert_select "form[action=?][method=?]", time_logs_path, "post" do
    end
  end
end
