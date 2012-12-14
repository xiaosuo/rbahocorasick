# RBAhoCorasick

A Ruby implementation of [the Aho-Corasick string matching algorithm](http://en.wikipedia.org/wiki/Aho%E2%80%93Corasick_string_matching_algorithm).

## Installation

Add this line to your application's Gemfile:

    gem 'rbahocorasick'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rbahocorasick

## Usage

````ruby
require 'rubygems'
require 'rbahocorasick'

nfa = RBAhoCorasick::NFA.new
%w{he she his hers}.each{|key| nfa.add(key)}
nfa.finalize
nfa.match('he and she are friends').each{|m| puts m.key}
````

Yes, you can use DFA instead of NFA for better performance. See `test/tc_nfa.rb`
for more examples.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
