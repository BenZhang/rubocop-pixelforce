require 'spec_helper'
require 'yaml'

RSpec.describe RuboCop::Cop::Pixelforce::EmptyLineBetweenCategories, :config do
  let(:config) do
    RuboCop::Config.new(YAML.load_file('default.yml'), '/some/.rubocop.yml')
  end

  include RuboCop::RSpec::ExpectOffense

  it 'registers an offense for missing empty line between categories' do
    expect_offense(<<~RUBY)
      class EmptyLine < ActiveRecord::Base
        belongs_to :user
        belongs_to :category
        after_commit :update_geo_location
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use empty lines between categories.
      end
    RUBY
  end

  it 'does not register an offense when empty lines are correct' do
    expect_no_offenses(<<~RUBY)
      class EmptyLine < ActiveRecord::Base
        belongs_to :user
        belongs_to :category

        after_commit :update_geo_location

        def test
          puts 'test'
        end

        def test2
          puts 'test2'
        end

        def self.test3
          puts 'test3'
        end

        def self.test4
          puts 'test4'
        end
      end
    RUBY
  end

  it 'registers multiple offenses for multiple missing/extra empty lines' do
    expect_offense(<<~RUBY)
      class EmptyLine < ActiveRecord::Base
        include EmptyLineLib
        belongs_to :user
        ^^^^^^^^^^^^^^^^ Use empty lines between categories.
        belongs_to :category
        before_create :check_empty_line
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use empty lines between categories.
        before_create :check_another_empty_line
        after_commit :update_geo_location
        enum empty_line: [0, 1]
        ^^^^^^^^^^^^^^^^^^^^^^^ Use empty lines between categories.
        attr_accessor :empty_line_attr
        validates :should_have_empty_line_above
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use empty lines between categories.
      end
    RUBY
  end

  it 'auto-corrects missing/extra empty lines between categories' do
    expect_offense(<<~RUBY)
      class EmptyLine < ActiveRecord::Base
        include EmptyLineLib
        belongs_to :user
        ^^^^^^^^^^^^^^^^ Use empty lines between categories.

        belongs_to :category
        ^^^^^^^^^^^^^^^^^^^^ Don't Use empty lines between same categories.

        before_create :check_empty_line

        before_create :check_another_empty_line
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Don't Use empty lines between same categories.
        after_commit :update_geo_location
        enum empty_line: [0, 1]
        ^^^^^^^^^^^^^^^^^^^^^^^ Use empty lines between categories.
        attr_accessor :empty_line_attr
        validates :should_have_empty_line_above
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use empty lines between categories.

      end
    RUBY

    expect_correction(<<~RUBY)
      class EmptyLine < ActiveRecord::Base
        include EmptyLineLib

        belongs_to :user
        belongs_to :category

        before_create :check_empty_line
        before_create :check_another_empty_line
        after_commit :update_geo_location

        enum empty_line: [0, 1]
        attr_accessor :empty_line_attr

        validates :should_have_empty_line_above

      end
    RUBY
  end
end
