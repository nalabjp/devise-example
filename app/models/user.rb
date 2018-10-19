require_relative 'legacy_user'

class User < LegacyUser
  LEGACY_USER_INFORMATION_ATTRIBUTES = %i(email)

  def valid?(context = nil)
    super

    unless legacy_user_information.valid?(context)
      legacy_user_information.errors.each do |attribute, message|
        errors.add(attribute, message)
      end
    end

    errors.empty?
  end

  def save(*args, &block)
    begin
      ApplicationRecord.transaction do
        raise ActiveRecord::RecordNotSaved unless super && legacy_user_information.save!(*args, &block)
      end
      true
    rescue
      false
    end
  end

  def save!(*args, &block)
    save(*args, &block) || raise(ActiveRecord::RecordNotSaved.new("Failed to save the record", self))
  end

  def assign_attributes(params)
    information_params = params.slice(*LEGACY_USER_INFORMATION_ATTRIBUTES)

    super
    legacy_user_information.assign_attributes(information_params)
  end

  def email
    legacy_user_information&.email || super
  end

  def email=(email)
    super
    legacy_user_information.email = email
  end


  def legacy_user_information
    super || (new_record? ? build_legacy_user_information : nil)
  end
end
