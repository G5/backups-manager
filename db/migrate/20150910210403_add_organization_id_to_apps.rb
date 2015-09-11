class AddOrganizationIdToApps < ActiveRecord::Migration
  def change
    change_table :apps do |t|
      t.references :organization, index: true
    end
  end
end
