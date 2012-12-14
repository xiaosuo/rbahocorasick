
require 'rbahocorasick/nfa'

module RBAhoCorasick
  class DFA < RBAhoCorasick::NFA
    def finalize
      super
      queue = []
      (0..255).each do |byte|
        unless @initial_state[byte] == @initial_state
          queue << @initial_state[byte] 
        end
      end
      while queue.length > 0
        r = queue.shift
        (0..255).each do |byte|
          if s = r[byte]
            queue << s
          else
            r[byte] = r.default[byte]
          end
        end
      end
    end
  end
end
