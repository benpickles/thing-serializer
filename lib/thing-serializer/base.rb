require 'thing-serializer/dsl'

module ThingSerializer
  module Base
    def self.included(base)
      base.extend DSL
    end

    def initialize(object)
      @object = object
    end

    def as_json(*_)
      self.class.config.properties.inject({}) { |memo, name|
        memo[name] = value_for_property(name)
        memo
      }
    end

    private
      attr_reader :object

      def value_for_property(name)
        if self.respond_to?(name)
          self.public_send(name)
        elsif object.respond_to?(name)
          object.public_send(name)
        else
          raise "could not find property #{name.inspect}"
        end
      end
  end
end
