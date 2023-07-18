class Role < ApplicationRecord
    acts_as_paranoid
    #Validation Rules
    validates :name, presence: true, length: { maximum: 100 }, uniqueness: true
    validates :description, presence: true, length: { maximum: 100 }
end
