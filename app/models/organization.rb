class Organization < ActiveRecord::Base
  validates :email, :guid, presence: true

  has_many :apps
end
