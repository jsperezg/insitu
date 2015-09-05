require 'rails_helper'

RSpec.describe "time_logs/edit", type: :view do
  before(:each) do
    @time_log = assign(:time_log, TimeLog.create!(
      :description => "MyString",
      :end_time => "",
      :project => nil
    ))
  end

  it "renders the edit time_log form" do
    render

    assert_select "form[action=?][method=?]", time_log_path(@time_log), "post" do

      assert_select "input#time_log_description[name=?]", "time_log[description]"

      assert_select "input#time_log_end_time[name=?]", "time_log[end_time]"

      assert_select "input#time_log_project_id[name=?]", "time_log[project_id]"
    end
  end
end
