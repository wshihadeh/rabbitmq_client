# RubyCriticSmallBadge

[![Gem Version](https://badge.fury.io/rb/rubycritic-small-badge.svg)](https://badge.fury.io/rb/rubycritic-small-badge)
[![Build Status](https://api.travis-ci.org/MarcGrimme/rubycritic-small-badge.svg?branch=master)](https://secure.travis-ci.org/MarcGrimme/rubycritic-small-badge)
[![Depfu](https://badges.depfu.com/badges/48a6c1c7c649f62eede6ffa2be843180/count.svg)](https://depfu.com/github/MarcGrimme/rubycritic-small-badge?project_id=6900)
[![Coverage](https://marcgrimme.github.io/rubycritic-small-badge/badges/coverage_badge_total.svg)](https://marcgrimme.github.io/rubycritic-small-badge/coverage/index.html)
[![RubyCritic](https://marcgrimme.github.io/rubycritic-small-badge/badges/rubycritic_badge_score.svg)](https://marcgrimme.github.io/rubycritic-small-badge/tmp/rubycritic/overview.html)

*RubyCriticCovBadge* is a gem that can be added to the `Gemfile` and will produce a file called `rubycritic_badge_score.svg` in the `badges` directory.
It could be looking as follows dependent on how it is configured.

![Coverage](https://marcgrimme.github.io/rubycritic-small-badge/badges/coverage_badge_total.svg)

The idea is to created a badge for [RubyCritic](https://github.com/whitesmith/rubycritic) to create a persistable image that shows the score as a badge.

## Installation

The badge creation is dependent on the [RepoSmallBadge gem](https://github.com/marcgrimme/repo-small-badge).
It can be installed in your Ruby library or rails app as part of the `Gemfile` as follows.

```
# In your gemfile
gem 'rubycritic-small-badge', :require => false
```

This gem is an alternative and inspired by the great work in the other gem [simplecov-badge](https://github.com/matthew342/simplecov-badge) which does a similar badge but looks different and cannot easily made small. So it's mostly an optical alternative.

## Usage

Whereever you are integrating `Rubycritic` you can have to integrate as a Raketask. The default integration could looks as follows:

```Rakefile
require 'rubycritic_small_badge'
require 'rubycritic/rake_task'
RubyCriticSmallBadge.configure do |config|
  config.minimum_score = 90
end
RubyCritic::RakeTask.new do |task|
  task.options = %(--formatter RubyCriticSmallBadge::Report
--minimum-score #{RubyCriticSmallBadge.config.minimum_score})
end
```

## Integration into Travis-CI via github-pages

This process is split into two steps.

1. You need to create an access token for you github repository that can be configured to travis to allow password-less pushing. This is described in [Github Help - Authenticating to GitHub / Creating a personal access token for the command line](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/)

2. Configure travis to push the result to github-pages inspired from [the Travis description](https://docs.travis-ci.com/user/deployment/pages/) and configuration to be found in [.travis.yml](.travis.yml)

3. Integrate your badge into the README.md as follows ``![Coverage](https://marcgrimme.github.io/simplecov-small-badge/badges/coverage_badge_total.png)``

## Configuration Options

The behaviour of `RubyCriticmallBadge` can be influenced by configuration options as defined in the [configuration class](lib/rubycritic_small_badge/configuration.rb).

## Development

After checking out the repo, run `bundle update` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/marcgrimme/rubycritic-small-badge/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
