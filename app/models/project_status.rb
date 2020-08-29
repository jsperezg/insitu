# frozen_string_literal: true

class ProjectStatus < ActiveRecord::Base
  def locale_name
    I18n.t(name)
  end
end
