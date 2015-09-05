require 'rails_helper'

RSpec.describe "time_logs/new", type: :view do
  before(:each) do
    assign(:time_log, TimeLog.new(
      :description => "MyString",
      :end_time => "",
      :project => nil
    ))
  end

  it "renders new time_log form" do
    render

    assert_select "form[action=?][method=?]", time_logs_path, "post" do

      assert_select "input#time_log_description[name=?]", "time_log[description]"

      assert_select "input#time_log_end_time[name=?]", "time_log[end_time]"

      assert_select "input#time_log_project_id[name=?]", "time_log[project_id]"
    end
  end
end
