
require 'rbahocorasick/state'

module RBAhoCorasick
  MatchData = Struct.new(:key, :value, :offset)

  class NFA
    attr_reader :initial_state, :states_by_state_id

    def initialize
      @least_unused_state_id = 0
      @states_by_state_id = []
      @initial_state = create_state
    end

    # Add a pair of key and value
    def add(key, value = nil)
      @finalized and raise 'finalized'
      state = @initial_state
      key.each_byte do |byte|
        next_state = state[byte]
        unless next_state
          next_state = state[byte] = create_state
        end
        state = next_state
      end
      state.add(key, value)
    end

    # Finalize the state machine
    def finalize
      @finalized and raise 'finalize twice'
      @finalized = true
      queue = []
      (0..255).each do |byte|
        if @initial_state[byte]
          next_state = @initial_state[byte]
          next_state.default = @initial_state
          queue << next_state
        else
          @initial_state[byte] = @initial_state
        end
      end

      while queue.length > 0
        r = queue.shift
        (0..255).each do |byte|
          if s = r[byte]
            queue << s
            state = r.default
            state = state.default until state[byte]
            s.default = state[byte]
            s.data.concat(s.default.data)
          end
        end
      end
    end

    # Match the data
    def match(data, length = nil)
      finalize unless @finalized
      length ||= data.length
      matches = [] unless block_given?
      offset = 0
      state = @initial_state
      data.each_byte do |byte|
        break if offset >= length
        offset += 1
        state = state.default until state[byte]
        state = state[byte]
        if state.data.length > 0
          state.data.each do |state_data|
            match_data = RBAhoCorasick::MatchData.new(state_data.key,
              state_data.value, offset - state_data.key.length)
            if block_given?
              yield match_data
            else
              matches << match_data
            end
          end
        end
      end
      return matches unless block_given?
    end

    private

    def create_state
      state = RBAhoCorasick::State.new(@least_unused_state_id)
      @least_unused_state_id += 1
      @states_by_state_id[state.state_id] = state
      state
    end
  end
end
