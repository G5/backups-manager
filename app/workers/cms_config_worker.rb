class CmsConfigWorker
  include Sidekiq::Worker
  include WorkersHelper

  def perform
    @cms_list = App.all.select { |a| a.name[/g5-cms-/] }
    @cms_list.each { |cms| HTTPClient.post(cms_url(cms), {}) }
  end

  def cms_url(cms)
    "https://#{cms.name}.herokuapp.com/config_update"
  end
end
