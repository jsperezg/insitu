require 'rails_helper'

RSpec.describe 'plans/edit', type: :view do
  let(:user) { create(:user, :admin) }
  let(:plan) { create(:plan) }
  before(:each) do
    sign_in user
    assign(:plan, plan)
  end

  after(:each) do
    sign_out user
  end

  it 'renders the edit plan form' do
    render

    assert_select 'form[action=?][method=?]', plan_path(plan), 'post' do
    end
  end
end
