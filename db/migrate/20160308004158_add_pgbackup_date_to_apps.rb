class AddPgbackupDateToApps < ActiveRecord::Migration
  def change
    add_column :apps, :pgbackup_date, :string
  end
end
