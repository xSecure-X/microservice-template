module User
class UserCreator
  def initialize(user_params)
    @user_params = user_params
  end

  def create_user
    User.create(@user_params)
  end

  def update_user(user)
    user.update(@user_params)
    user
  end

  def delete_user(user)
    user.destroy
  end
end
end

