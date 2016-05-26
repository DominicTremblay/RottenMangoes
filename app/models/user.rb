class User < ActiveRecord::Base

  has_many :reviews

  has_secure_password

  def full_name
    "#{firstname} #{lastname}"
  end

  def admin?
    admin_user
  end

  def current_user
    @user = User.find(params[:id])    
  end

end
