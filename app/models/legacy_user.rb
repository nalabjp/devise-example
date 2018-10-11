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
end
