# Rubocop::Pixelforce

Custom Rubocop cop for PixelForce

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rubocop-pixelforce'
```

And then execute:

    $ bundle

Create a `.rubocop.yml` file in your project root:

```yaml
inherit_gem:
  rubocop-pixelforce: default.yml
```

### Dependencies

This gem automatically includes the following dependencies:
- `rubocop-performance` - for performance-related cops
- `rubocop-rails` - for Rails-specific cops

If you encounter any issues with missing cops, make sure these gems are properly installed.

## Usage

### Pixelforce/EmptyLineBetweenCategories: Don't Use empty lines between same categories.

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

### Pixelforce/EmptyLineBetweenCategories: Use empty lines between categories.

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

## Troubleshooting

### Error: "Rails cops have been extracted to the rubocop-rails gem"

If you see this error, it means the `rubocop-rails` plugin is not properly loaded. This gem automatically includes `rubocop-rails` as a dependency, but if you're still seeing this error:

1. Make sure you're using the latest version of this gem
2. Run `bundle update rubocop-pixelforce` to update to the latest version
3. Ensure your `.rubocop.yml` inherits from this gem's configuration:
   ```yaml
   inherit_gem:
     rubocop-pixelforce: default.yml
   ```

### Error: "unrecognized cop or department"

If you see errors about unrecognized cops, make sure you have the latest version of RuboCop and this gem installed:

```bash
bundle update rubocop rubocop-pixelforce
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/BenZhang/rubocop-pixelforce.
