class User < ApplicationRecord
    # Validation rules
    validates :full_name, presence: true, length: { maximum: 100 }
    validates :email, presence: true, length: { maximum: 100 }
    validates :roles, length: { maximum: 100 }
    validates :status, presence: true, numericality: { only_integer: true }
    validates :company_id, presence: true
    validates :created_date, presence: true
    validates :modified_date, presence: true
    validates :deleted_date, presence: true

    before_create :assign_created_date

    private

    def assign_created_date
      self.created_date = Time.now.utc
    end
end
  