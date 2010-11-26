require 'test_helper'

class ChangelogTest < ActiveSupport::TestCase
  load_schema
  
  def test_changelog
    assert_kind_of Changelog, Changelog.new
  end
end
