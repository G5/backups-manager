class AddPgBackupIdToApps < ActiveRecord::Migration
  def change
    add_column :apps, :pgbackup_id, :string
  end
end
