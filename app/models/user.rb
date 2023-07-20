class User < ApplicationRecord
  acts_as_paranoid
  validates :full_name, presence: true, length: { maximum: 100 }
  validates :email, presence: true, length: { maximum: 100 }, uniqueness: true
  validates :roles, length: { maximum: 100 }
  validates :status, presence: true, numericality: { only_integer: true }
  validates :company_id, presence: false

  delegate :can?, :cannot?, to: :ability

  def ability
    @ability ||= Ability.new(self)
  end

devise :database_authenticatable, :registerable, :rememberable,
:omniauthable, omniauth_providers: [:google_oauth2]

    alias_attribute :updated_at, :modified_at
    private

    def self.from_omniauth(auth)
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
  
        user.id = auth.uid
        user.email = auth.info.email
        user.password = Devise.friendly_token[0,20]
        user.full_name = auth.info.name
        user.roles = "cliente"
        user.status = 1
        user.company_id = auth.uid
        user.uid = auth.uid
      end
    end
end