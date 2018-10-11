require_relative 'legacy_user'

class User
  include ActiveModel::Model

  class << self
    def respond_to?(name, include_all = false)
      LegacyUser.respond_to?(name, include_all)
    end

    def respond_to_missing?(symbol, include_private)
      LegacyUser.send(:respond_to_missing?, symbol, include_private)
    end

    def method_missing(name, *args, &block)
      if LegacyUser.respond_to?(name)
        LegacyUser.send(name, *args, &block)
      else
        super
      end
    end
  end

  def respond_to?(name, include_all = false)
    legacy_user.respond_to?(name, include_all)
  end

  def respond_to_missing?(symbol, include_private)
    legacy_user.send(:respond_to_missing?, symbol, include_private)
  end

  def method_missing(name, *args, &block)
    if legacy_user.respond_to?(name)
      legacy_user.send(name, *args, &block)
    else
      super
    end
  end

  private

  def legacy_user
    return @legacy_user if defined?(@legacy_user)
    @legacy_user = LegacyUser.new
  end
end
