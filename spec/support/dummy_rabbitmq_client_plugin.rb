# frozen_string_literal: true

class DummyRabbitmqClientPlugin < RabbitmqClient::Plugin
  callbacks do |lifecycle|
    lifecycle.before(:publish) do |_message, options|
      options[:user_id] = '10101010'
      options[:user_name] = 'JohnDeo'
    end
    lifecycle.after(:publish) do |_delivery_info, _properties, _payload|
      options[:user_id] = nil
    end
  end
end
