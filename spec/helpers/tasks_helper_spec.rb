require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the TasksHelper. For example:
#
# describe TasksHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe TasksHelper, type: :helper do
  describe "task_tr" do
    it "on finished task" do
      task = create(:task, finish_date: DateTime.now - 1.day)
      html_row = helper.task_tr(task) do
      end

      expect(html_row).to include('success')
    end

    it "on active task" do
      task = create(:task, finish_date: nil, dead_line: nil)
      html_row = helper.task_tr(task) do
      end

      expect(html_row).to include('active')
    end

    it "on finishing task" do
      task = create(:task, finish_date: nil, dead_line: Date.today)
      html_row = helper.task_tr(task) do
      end

      expect(html_row).to include('warning')
    end

    it "on outdated task" do
      task = create(:task, finish_date: nil, dead_line: Date.today - 1.day)
      html_row = helper.task_tr(task) do
      end

      expect(html_row).to include('danger')
    end
  end
end
