class Organization < ActiveRecord::Base
  validates :email, :guid, presence: true

  has_many :apps

  def name
    email.match(/(.+)@/)[1]
  end
end
