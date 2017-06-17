module ThingSerializer
  class Config
    attr_reader :properties

    def initialize
      @properties = []
    end

    def add(name)
      @properties << name
    end
  end
end
