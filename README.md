# rails5_xhr_update

rails5_xhr_update is a program that can be used to help convert from the:

```ruby
xhr :get, :action
```

test syntax used in rails prior to Rails 5, to the Rails 5 syntax:

```ruby
get :action, xhr: true
```

## Installation

To install rails5_xhr_update run:

    gem install rails5_xhr_udpate


## Running

Simply run:

```sh
rails5_xhr_update --write FILE...
```

Omit ``--write`` if you don't want to write back to the files, and instead
output to STDOUT.

Consider running the following to find files with potential issues:

```sh
git grep -l "xhr :" | xargs rails5_xhr_update --write
```
