# frozen_string_literal: true

module MonkeyPatches
  module ActiveSupport
    # Adds support for translated timezones
    module TimeZone
      def to_s
        translated_name = I18n.t(name, scope: :timezones, default: name)
        "(GMT#{formatted_offset}) #{translated_name}"
      end
    end
  end
end

ActiveSupport::TimeZone.prepend MonkeyPatches::ActiveSupport::TimeZone
