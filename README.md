Rack::SpellCheck
----------------

__WARNING: THIS GEM IS UNDER DEVELOPMENT AND NOT ACUTALLY STABLE/USABLE/RELEASED!!!__

Spell check your HTML pages with Aspell, Nokogiri, and Rack. Your log files will
give you misspelled words and possible corrections. For instance, this is a Rails
log file with rack-spell-check installed:

```
Started GET "/" for 127.0.0.1 at 2012-02-29 15:05:34 -0500
 Processing by Main::DashboardController#show as HTML
Rendered main/dashboard/show.erb within layouts/marketing (5.0ms)
Rendered layouts/_header.erb (31.3ms)
Rendered layouts/_footer.erb (0.6ms)
Completed 200 OK in 81ms (Views: 80.5ms)
SpellCheck [workflow]: work flow, work-flow, workfare, workforce, workable, forkful
SpellCheck [walkthrough]: walk through, walk-through, breakthrough, walkabout, Valkyrie, Walker
SpellCheck [frontmatter]: front matter, front-matter, frontward, antimatter, fronted, frontier
SpellCheck [subdomain]: sub domain, sub-domain, subhuman, subliming, subsuming, sideman
SpellCheck [dns]: Dons, dens, dins, dons, duns, DNA
SpellChecked in 0.244784 seconds.
```

--
**Installation**

Add `rack-spell-check` to your `Gemfile`. If you use Rails, the spellchecker will
automatically add itself to your rack middleware.

``` ruby
group :development do
  gem 'rack-spell-check'
end
```

If you don't use Rails, you will need to add `Rack::SpellCheck` to your middleware
manually. One good way to do this is in your `config.ru` file.

``` ruby
# Load up the environment & bundler first, then:

use Rack::SpellCheck
run Sinatra::Application # Or whatever your application is called.
```

--
**More Information**

Written by Matt Beale (matt.beale@madhatted.com)

Inspired by:

* https://gist.github.com/1944060
* http://blog.atwam.com/blog/2012/02/25/spell-checking-should-be-part-of-your-view-tests