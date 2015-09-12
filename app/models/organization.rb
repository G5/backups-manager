class Organization < ActiveRecord::Base
  has_many :apps
  has_many :invoices

  validates :email, :guid, presence: true

  def name
    email.match(/(.+)@/)[1]
  end
end
