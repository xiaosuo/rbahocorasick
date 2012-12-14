
module RBAhoCorasick
  StateData = Struct.new(:key, :value)

  class State
    attr_accessor :data, :default
    attr_reader :state_id

    def initialize(state_id)
      @transition = []
      @data = []
      @state_id = state_id
    end

    def add(key, value)
      @data << RBAhoCorasick::StateData.new(key, value)
    end

    def ==(o)
      @state_id == o.state_id
    end

    def [](input)
      @transition[input]
    end

    def []=(input, next_state)
      @transition[input] and raise 'transition exists'
      @transition[input] = next_state
    end
  end
end
