# Gosui

Gosui is a bare-bones GUI for a bare-bones 2D game engine: Gosu.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gosui'
```

And then execute:

`$ bundle`

Or install it yourself as:

`$ gem install gosui`

## Usage

### In the Window

At the top of the file, type
```ruby
require 'gosui'
```

For each input device in the game, you must first create it using the instructions provided individually. Next, each device must call `update` and `draw` in your window's `update` and `draw` methods.

### Slider

The slider is an important piece of functionality in Gosui. To create one, use
`Slider.new()`
The arguments are
- window - The current game window.
- x, y - The x and y coordinates of the slider. Exact position is at the top-left corner of the bar itself.
- length - The display length of the slider.
- max - The value when the selector is all the way to the right.
Optional arguments are listed below. To access any of them, you must use the syntax `[argument]: [value]`
- min - The value when the selector is all the way to the left.
- value - The initial value of the selector, ranging from your minimum value to your maximum value.
- markers - The number of extra indicators on the bar. For example,
```ruby
Slider.new(self, 30, 30, 0, 200, 100, markers: 3)
```
creates
![Alt text](markers.png?raw=true){width: 300px;}
- color - The `Gosu::Color` of the bar, selector, and text.
- text - Determines whether or not to display text.
- scale - The scale of the entire slider. Warning! Scaling up may require modifying the length, otherwise the text may get crowded.
- label - A label for your slider. Appears on the top-left corner.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ASlated/gosui. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
