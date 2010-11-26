require 'test_helper'

class Movie < ActiveRecord::Base
  log_changes :ignore => [:timestamps]
end

class ActiveRecordChangelogTest < ActiveSupport::TestCase
  test "schema_loaded_properlly" do
    assert_equal [], Movie.all
  end

  test "should_add_changelogs_to_models" do
    assert Movie.new.respond_to?(:changelogs)
    assert_equal [], Movie.new.changelogs.all
  end

  test "should_not_create_changelog_on_create" do
    movie = Movie.new(:title => 'Transformers', :description => 'Shitty movie!')
    movie.save
    assert_equal [], movie.changelogs
  end

  test "should_create_changelog_on_update" do
    movie = Movie.new(:title => 'Transformers', :description => 'Shitty movie!')
    movie.save

    changelog_length = movie.changelogs.length

    movie.title = 'Transformers 2'
    movie.save

    assert_equal changelog_length + 1, movie.changelogs.length
  end

  test "should_not_create_changelog_when_fields_did_not_change" do
    movie = Movie.new(:title => 'Transformers', :description => 'Shitty movie!')
    movie.save

    changelog_length = movie.changelogs.length

    movie.title = 'Transformers'
    movie.description = 'Shitty movie!'
    movie.save

    assert_equal changelog_length, movie.changelogs.length
  end

  test "should_have_all_change_fields_included_in_the_fields_changed" do
    movie = Movie.new(:title => 'Transformers', :description => 'Shitty movie!')
    movie.save

    changelog_length = movie.changelogs.length

    movie.title = 'Transformers 2'
    movie.description = 'A Shitier movie than the first!'
    movie.save

    changelog = movie.changelogs.first
    assert changelog.fields_changed.split(',').include?('title')
    assert changelog.fields_changed.split(',').include?('description')
  end

  test "should_ignore_fields_ignored" do
    class Movie < ActiveRecord::Base
      log_changes :ignore => [:description]
    end

    movie = Movie.new(:title => 'Transformers', :description => 'Shitty movie!')
    movie.save

    changelog_length = movie.changelogs.length

    movie.title = 'Transformers 2'
    movie.description = 'A Shitier movie than the first!'
    movie.save

    changelog = movie.changelogs.first
    assert changelog.fields_changed.split(',').include?('title')
    assert !changelog.fields_changed.split(',').include?('description')
  end
end
