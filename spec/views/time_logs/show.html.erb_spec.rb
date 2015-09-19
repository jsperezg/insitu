require 'rails_helper'

RSpec.describe "time_logs/show", type: :view do
  before(:each) do
    @time_log = assign(:time_log, TimeLog.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
