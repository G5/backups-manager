class Invoice < ActiveRecord::Base
  default_scope { order("period_start DESC") }
  belongs_to :organization

  validates :organization, :total, :period_start, :period_end, presence: true
end
