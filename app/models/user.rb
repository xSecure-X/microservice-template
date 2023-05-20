class User < ApplicationRecord

# Include default devise modules. Others available are:
# :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
devise :database_authenticatable, :registerable,
:recoverable, :rememberable, :validatable,
:omniauthable, omniauth_providers: [:google_oauth2]

    before_create :assign_created_date

    private

    def assign_created_date
      self.created_date = Time.now.utc
      self.modified_date = Time.now.utc
    end

    def self.from_omniauth(auth)
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        #user.email = auth.info.email
        #user.password = Devise.friendly_token[0,20]
        #user.full_name = auth.info.name
        #preguntar de roles
       # user.status = 1
        #user.company_id = "google"
        #user.roles = "cliente"
        #user.avatar_url = auth.info.image
        #user.uid = auth.info.uid
        #user.created_date = Time.now.utc
        #user.modified_date = Time.now.utc
        user.id = auth.uid
        user.email = auth.info.email
        user.password = Devise.friendly_token[0,20]
        user.full_name = auth.info.name
        user.roles = "admin"
        user.status = 1
        user.company_id = auth.uid
        user.uid = auth.uid
        user.created_date = Time.now.utc
        user.modified_date = Time.now.utc
      end
    end

end
  