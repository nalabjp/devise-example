class LegacyUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  ## For devise compatible with User

  # https://github.com/plataformatec/devise/blob/715192a7709a4c02127afb067e66230061b82cf2/test/mapping_test.rb#L76-L80
  def devise_scope
    :user
  end

  class << self
    def new(*)
      super.to_user
    end
  end

  def dup
    super.to_user
  end

  def clone
    super.to_user
  end

  def init_with(*)
    super.to_user
  end

  # The expected return value for behaviors delegated from initialization of User is an instance of User
  def to_user
    User.allocate.tap { |u| u.initialize_with_legacy_user(self) }
  end
end

# We can not delegate to a protected method, so change it to a public method
LegacyUser.protected_instance_methods.each { |method| LegacyUser.class_eval { public method } }
