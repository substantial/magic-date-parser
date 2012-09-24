# MagicDateParser

Parses a string representation of a date range and returns a start and end date. Returns nil when string is not
parsable.

## Installation

Add this line to your application's Gemfile:

    gem 'magic_date_parser'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install magic_date_parser

## Usage

```
require 'magic_date_parser'

start, end = MagicDateParser.range("December 4 - 7, 2007")
\# [#<Date: 2007-12-04 ((2454439j,0s,0n),+0s,2299161j)>, #<Date: 2007-12-07 ((2454442j,0s,0n),+0s,2299161j)>]

start, end = MagicDateParser.range("2008/January 2009")
\# [#<Date: 2008-01-01 ((2454467j,0s,0n),+0s,2299161j)>, #<Date: 2009-01-31 ((2454863j,0s,0n),+0s,2299161j)>]
```

See `spec/magic\_date\_parser\_spec.rb` for more examples.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
