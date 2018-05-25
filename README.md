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
git grep -l "xhr :" | rails5_xhr_update --write
```
