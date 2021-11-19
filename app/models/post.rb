class Post < ApplicationRecord
    has_many :comments, dependent: :destroy
    validates :title,  :presence => true
    validates :text, :presence => true,
                    :length => { :minimum => 5 }
    belongs_to :user
end
