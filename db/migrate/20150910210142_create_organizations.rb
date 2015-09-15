class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :email
      t.string :guid

      t.timestamps
    end
  end
end
