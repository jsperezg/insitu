# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  it 'role' do
    allow(helper).to receive(:current_user).and_return(create(:user, :admin))
    html_block = helper.role?('dummy|Administrator') do
      'Administrator'
    end
    expect(html_block).to eq('Administrator')
  end

  describe 'Navigation bar' do
    it 'Dashboard: Just tittle' do
      allow(controller).to receive(:controller_name).and_return('dashboard')
      allow(controller).to receive(:action_name).and_return('index')

      expect(helper.content_header).to include("<h1>#{I18n.t(NAVIGATION_RULES[:dashboard][:index][:title])}</h1>")
      expect(helper.content_header).not_to include('breadcrumb')
    end

    it '1 level depth' do
      allow(controller).to receive(:controller_name).and_return('units')
      allow(controller).to receive(:action_name).and_return('index')

      expect(helper.content_header).to include("<h1>#{I18n.t(NAVIGATION_RULES[:units][:index][:title])}</h1>")
      expect(helper.content_header).to include('breadcrumb')
      expect(helper.content_header).to include('fa fa-database')
    end
  end
end
