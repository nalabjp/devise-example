require_relative 'legacy_user'

class User
  LEGACY_USER_INFORMATION_ATTRIBUTES = %i(email)

  delegate_missing_to :legacy_user

  class << self
    delegate_missing_to :LegacyUser

    def new(params = {})
      LegacyUser.new.tap { |u| u.assign_attributes(params) }
    end

    # For devise `registerable`
    # https://github.com/plataformatec/devise/blob/75f9e76f65d2fd9892631efd0221ebe1921344b7/lib/devise/models/registerable.rb#L21-L23
    #
    # LegacyUser instance has `#new_with_session`.
    # But it is necessary to initialize the User in order to initialize LegacyUserInformation.
    def new_with_session(hash, _session)
      new(hash)
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

  def valid?
    legacy_user.valid?

    unless legacy_user_information.valid?
      legacy_user_information.errors.each do |attribute, message|
        errors.add(attribute, message)
      end
    end

    errors.empty?
  end

  def save(opts = {})
    valid? ? save_multiple(opts) : false
  end

  def save!(opts = {})
    valid? ? save_multiple(opts) : raise_validation_error
  end

  def assign_attributes(params)
    information_params = params.slice(*LEGACY_USER_INFORMATION_ATTRIBUTES)

    legacy_user.assign_attributes(params)
    legacy_user_information.assign_attributes(information_params)
  end

  def email
    legacy_user_information&.email ||
      legacy_user.email
  end

  def email=(email)
    legacy_user.email = email
    legacy_user_information.email = email
  end

  private

  def legacy_user
    return @legacy_user if defined?(@legacy_user)
    @legacy_user = LegacyUser.new
  end

  def legacy_user_information
    return @legacy_user_information if defined?(@legacy_user_information)
    if legacy_user.new_record?
      @legacy_user_information = legacy_user.legacy_user_information || legacy_user.build_legacy_user_information
    else
      @legacy_user_information = legacy_user.legacy_user_information
    end
  end

  def save_multiple(opts = {})
    begin
      ApplicationRecord.transaction do
        legacy_user.save!(opts)
        legacy_user_information.save!(opts)
      end
      true
    rescue
      false
    end
  end

  def raise_validation_error
    raise ActiveRecord::RecordInvalid.new("Validation failed: #{errors.full_messages.join(', ')}")
  end
end
