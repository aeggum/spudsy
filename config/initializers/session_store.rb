# Be sure to restart your server when you modify this file.

#Spudsy::Application.config.session_store :cookie_store, :key => '_demo_app_session'

Spudsy::Application.config.session_store :active_record_store

module ActionController
  module Flash
    class FlashHash < Hash
      def method_missing(m, *a, &b)
      end
    end
  end
end
# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# Spudsy::Application.config.session_store :active_record_store
