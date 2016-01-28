class AddBackupTransferSuccessToApps < ActiveRecord::Migration
  def change
    add_column :apps, :backup_transfer_success, :boolean, default: false
  end
end
