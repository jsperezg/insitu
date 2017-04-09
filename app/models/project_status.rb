class ProjectStatus < ApplicationRecord
  def locale_name
    I18n.t(name)
  end
end
