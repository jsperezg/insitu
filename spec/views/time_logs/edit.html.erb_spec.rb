require 'rails_helper'

RSpec.describe "time_logs/edit", type: :view do
  before(:each) do
    @time_log = assign(:time_log, TimeLog.create!())
  end

  it "renders the edit time_log form" do
    render

    assert_select "form[action=?][method=?]", time_log_path(@time_log), "post" do
    end
  end
end
