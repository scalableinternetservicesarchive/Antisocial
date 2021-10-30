class Post < ApplicationRecord
    validates :title,  :presence => true
    validates :text, :presence => true,
                    :length => { :minimum => 5 }
end
