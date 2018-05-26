[![Gem](https://img.shields.io/gem/v/rails5_xhr_update.svg)](https://rubygems.org/gems/rails5_xhr_update)
[![Build Status](https://travis-ci.org/appfolio/rails5_xhr_update.svg?branch=master)](https://travis-ci.org/appfolio/rails5_xhr_update)

# rails5_xhr_update

rails5_xhr_update is a program that can be used to help convert from the Rails
4 xhr test syntax, like the following:

```ruby
xhr :get, images_path, limit: 10, sort: 'new'
```

to the equivalent Rails 5 syntax:

```ruby
get images_path, params: { limit: 10, sort: 'new' }, xhr: true
```

Furthermore, `xhr` calls using `session`, or `flash` parameters are also
supported. The following call:

```ruby
xhr :get, images_path, { id: 1 }, { user_ud: 2 }, success: 'logged in'
```

is translated into:

```ruby
get images_path, flash: { success: "logged in" }, params: { id: 1 }, session: { user_ud: 2 }, xhr: true
```

## Installation

To install rails5_xhr_update run:

    gem install rails5_xhr_udpate


## Running

Execute this program via:

```sh
rails5_xhr_update --write FILE...
```

Omit ``--write`` if you don't want to write back to the files, and instead
output to STDOUT.

Consider running the following to locate and run against files with potential
issues:

```sh
git grep -l "xhr :" | rails5_xhr_update --write
```


## See Also

### Handling non-XHR cases

As part of the upgrade to Rails 5 one also needs to use keyword arguments for
`params` and `headers` when calling these *request* test methods. Fortunately,
[rubocop](https://github.com/bbatsov/rubocop) can help handle that conversion:


```sh
rubocop -a --only Rails/HttpPositionalArguments PATH
```

### Supporting Rails 5 syntax in Rails 4

Finally, with your project, it might be difficult to do all this conversion
work at once. You might instead, prefer to remain on Rails 4, but be forward
compatible with Rails 5. And you might want to output a `DeprecationWarning`,
or even raise an exception when attempting to use the older syntax. To help
with that please see our
[rails-forward_compatible_controller_tests](https://github.com/appfolio/rails-forward_compatible_controller_tests)
gem.
