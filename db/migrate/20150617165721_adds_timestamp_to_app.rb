class AddsTimestampToApp < ActiveRecord::Migration
  def change
    add_column(:apps, :created_at, :datetime)
    add_column(:apps, :updated_at, :datetime) 
  end
end
