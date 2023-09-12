class UserRole < ApplicationRecord
    acts_as_paranoid
    belongs_to :user, foreign_key: :userId
    belongs_to :role, foreign_key: :roleId

    validates :userId, uniqueness: { scope: :roleId, message: 'User already has this role.' }
end
