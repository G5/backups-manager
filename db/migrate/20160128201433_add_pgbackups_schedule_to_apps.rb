class AddPgbackupsScheduleToApps < ActiveRecord::Migration
  def change
    add_column :apps, :backup_schedule, :string
  end
end
