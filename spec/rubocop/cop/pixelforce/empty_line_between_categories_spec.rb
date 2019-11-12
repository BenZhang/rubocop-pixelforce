require 'spec_helper'
require 'yaml'

RSpec.describe RuboCop::Cop::Pixelforce::EmptyLineBwteenCategories do
  subject(:cop) { described_class.new(config) }

  let(:config) do
    RuboCop::Config.new(
      YAML.load_file('default.yml'),
      '/some/.rubocop.yml'
    )
  end

  it "should have 1 offense" do
    inspect_source('
      class EmptyLine < ActiveRecord::Base
        belongs_to :user

        belongs_to :category

        after_commit :update_geo_location
      end
    ')
    expect(cop.offenses.size).to eq(1)
  end

  it "should have 0 offense" do
    inspect_source('
      class EmptyLine < ActiveRecord::Base
        belongs_to :user
        belongs_to :category

        after_commit :update_geo_location
      end
    ')
    expect(cop.offenses.size).to eq(0)
  end

  it "should have 5 offense" do
    inspect_source('
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
    ')
    expect(cop.offenses.size).to eq(5)
  end

  it 'should auto correct' do
    new_source = autocorrect_source('
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
    ')

    expect(new_source).to eq('
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
    ')
  end
end