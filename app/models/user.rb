require_relative 'legacy_user'

class User
  delegate_missing_to :legacy_user

  class << self
    delegate_missing_to :LegacyUser

    def new(params = {})
      LegacyUser.new(params)
    end
  end

  def initialize_with_legacy_user(legacy_user)
    @legacy_user = legacy_user
  end

  def dup
    legacy_user.dup
  end

  def clone
    legacy_user.clone
  end

  private

  def legacy_user
    return @legacy_user if defined?(@legacy_user)
    @legacy_user = LegacyUser.new
  end
end
