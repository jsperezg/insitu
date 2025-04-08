# frozen_string_literal: true

require 'rails_helper'

describe TasksHelper, type: :helper do
  describe 'task_tr' do
    it 'on finished task' do
      task = create(:task, finish_date: Time.current - 1.day)
      html_row = helper.task_tr(task) do
      end

      expect(html_row).to include('success')
    end

    it 'on active task' do
      task = create(:task, finish_date: nil, dead_line: nil)
      html_row = helper.task_tr(task) do
      end

      expect(html_row).to include('active')
    end

    it 'on finishing task' do
      task = create(:task, finish_date: nil, dead_line: Date.current)
      html_row = helper.task_tr(task) do
      end

      expect(html_row).to include('warning')
    end

    it 'on outdated task' do
      task = create(:task, finish_date: nil, dead_line: Date.current - 1.day)
      html_row = helper.task_tr(task) do
      end

      expect(html_row).to include('danger')
    end
  end
end
