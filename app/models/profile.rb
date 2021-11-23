class Profile < ApplicationRecord

  validates :first_name
  validates :last_name
  validates :address
  validates :gender
  belongs_to :user
end
