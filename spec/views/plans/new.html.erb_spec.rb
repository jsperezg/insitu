# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'plans/new', type: :view do
  before do
    assign(:plan, Plan.new)
  end

  it 'renders new plan form' do
    render

    assert_select 'form[action=?][method=?]', plans_path, 'post' do
    end
  end
end
