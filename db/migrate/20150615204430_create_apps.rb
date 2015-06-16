class CreateApps < ActiveRecord::Migration
  def change
    create_table :apps do |t|
      t.json :app_details
      t.json :dynos
      t.json :addons
      t.json :config_variables
      t.json :domains
    end
  end
end
