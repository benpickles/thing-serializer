require 'thing-serializer/config'

module ThingSerializer
  module DSL
    def attribute(name)
      config.add(name)
    end

    def attributes(*names)
      names.each do |name|
        attribute(name)
      end
    end

    def config
      @config ||= Config.new
    end

    def to_proc
      ->(object) { new(object) }
    end
  end
end
