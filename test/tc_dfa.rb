
require 'test/unit'
require 'rbahocorasick'

class TC_DFA < Test::Unit::TestCase
  # verify the state machine with the original paper
  def test_paper
    dfa = RBAhoCorasick::DFA.new
    %w{he she his hers}.each{|key| dfa.add(key)}
    dfa.finalize
    delta = {
      0 => {?h.ord => 1, ?s.ord => 3},
      1 => {?e.ord => 2, ?i.ord => 6, ?h.ord => 1, ?s.ord => 3},
      3 => {?h.ord => 4, ?s.ord => 3},
      7 => {?h.ord => 4, ?s.ord => 3},
      9 => {?h.ord => 4, ?s.ord => 3},
      5 => {?r.ord => 8, ?h.ord => 1, ?s.ord => 3},
      2 => {?r.ord => 8, ?h.ord => 1, ?s.ord => 3},
      6 => {?s.ord => 7, ?h.ord => 1},
      4 => {?e.ord => 5, ?i.ord => 6, ?h.ord=> 1, ?s.ord => 3},
      8 => {?s.ord => 9, ?h.ord => 1}
    }
    (0..9).each do |i|
      state = dfa.states_by_state_id[i]
      (0..255).each do |byte|
        expect = (delta[i][byte] || 0)
        assert_equal(expect, state[byte].state_id)
      end
    end
  end
end
