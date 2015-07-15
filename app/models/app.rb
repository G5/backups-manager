class App < ActiveRecord::Base
  def type
    App.type_from_name(self.name)
  end

  def self.type_from_name(name)
    return "" unless name.present?
    name_tokens = name.split("-")
    common = AppVersions.app_list.keys & name_tokens
    return "" unless common.present? && common.length == 1
    common.first
  end
end
