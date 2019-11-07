# Rubocop::Pixelforce

Custom Rubocop cop for PixlForce


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rubocop-pixelforce'
```

And then execute:

    $ bundle

and create .rubocop file like this

```
inherit_gem:
  rubocop-pixelforce: default.yml
```

## Pixelforce/ClassStructure: Don't Use empty lines between same categories.

```ruby
# bad
belongs_to :user

belongs_to :category

after_commit :update_geo_location

# good
belongs_to :user
belongs_to :category

after_commit :update_geo_location
```

## Pixelforce/ClassStructure: Use empty lines between categories.

```ruby
# bad
enum status: { draft: 0, active: 1, approved: 2, declined: 3 }
belongs_to :user
belongs_to :category
after_commit :update_geo_location

# good
enum status: { draft: 0, active: 1, approved: 2, declined: 3 }

belongs_to :user
belongs_to :category

after_commit :update_geo_location
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/rubocop-pixelforce.
