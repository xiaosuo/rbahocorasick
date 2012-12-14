
require 'test/unit'
require 'rbahocorasick'

class TC_NFA < Test::Unit::TestCase
  def setup
    @nfa = RBAhoCorasick::NFA.new
    %w{he she his hers}.each{|key| @nfa.add(key)}
  end

  # verify the state machine with the original paper
  def test_paper
    @nfa.finalize
    assert_equal(10, @nfa.states_by_state_id.length)
    assert_equal(0, @nfa.initial_state.state_id)
    goto = [
      {?h.ord => 1, ?s.ord => 3},
      {?e.ord => 2, ?i.ord => 6},
      {?r.ord => 8},
      {?h.ord => 4},
      {?e.ord => 5},
      {},
      {?s.ord => 7},
      {},
      {?s.ord => 9},
      {}
    ]
    (0...10).each{|i| assert_equal(i, @nfa.states_by_state_id[i].state_id)}
    f = [0, 0, 0, 0, 1, 2, 0, 3, 0, 3]
    output = {2 => ['he'], 5 => ['she', 'he'], 7 => ['his'], 9 => ['hers']}
    (0..9).each do |i|
      state = @nfa.states_by_state_id[i]
      # goto function
      (0..255).each do |byte|
        if goto[i][byte]
          assert_equal(goto[i][byte], state[byte].state_id)
        elsif i == 0
          assert_equal(0, state[byte].state_id)
        else
          assert_equal(nil, state[byte])
        end
      end
      # failure function
      if i == 0
        assert_equal(nil, state.default)
      else
        assert_equal(f[i], state.default.state_id)
      end
      # output function
      if output[i]
        assert_equal(output[i].length, state.data.length)
        keys = state.data.map{|data| data.key}
        output[i].each{|o| assert(keys.include?(o))}
      else
        assert_equal(0, @nfa.states_by_state_id[i].data.length)
      end
    end
  end

  # finalize should be optional
  def test_finalize
    matches = @nfa.match('he and she are friends')
    assert_equal(3, matches.length)
    assert_equal('he', matches[0].key)
    assert_equal(0, matches[0].offset)
    assert_equal('she', matches[1].key)
    assert_equal(7, matches[1].offset)
    assert_equal('he', matches[2].key)
    assert_equal(8, matches[2].offset)
    assert_raise(RuntimeError){@nfa.finalize}
    assert_raise(RuntimeError){@nfa.add('test')}
  end

  def test_match
    str = 'he and she are friends'
    # with length
    matches = @nfa.match(str, 9)
    assert_equal(1, matches.length)
    assert_equal('he', matches[0].key)
    assert_equal(0, matches[0].offset)
    # with block
    matches = []
    @nfa.match(str) do |match_data|
      matches << match_data.key
    end
    assert_equal(%w{he she he}, matches)
    # block return
    matches = []
    @nfa.match(str) do |match_data|
      matches << match_data.key
      break if match_data.key == 'she'
    end
    assert_equal(%w{he she}, matches)
  end

  def test_value_retrieve
    @nfa.add('key', 'value')
    matches = @nfa.match('she has his key')
    assert_equal(%w{she he his key}, matches.map{|m| m.key})
    (0...3).each{|i| assert_equal(nil, matches[i].value)}
    assert_equal('value', matches[3].value)
  end
end
