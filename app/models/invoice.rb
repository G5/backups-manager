class Invoice < ActiveRecord::Base
  belongs_to :organization

  validates :organization, :total, :period_start, :period_end, presence: true
end
