# persistent_params

Save params in session to use them again when the user goes to another page and
comes back. This gem adds a method to Rails controllers called `persists_params`
that adds this feature to that controller.

## What?

I have to deal with not-so-simple search forms in my `index` templates. It's
awful when I combine several filters, search for records, choose one of them
to see details and then go back to the `index` page just to see all my filters
gone and I have to set them all over.

With this gem, the controller will save the params in session and, when the
same action is invoked again with no params, the request is redirected to the
same path, but with the previous used params set.

It also offers a handy method to integrate with the `HasScope` gem, so `scopes`
are persisted between requests.

## Installation

In your Gemfile:

```ruby
gem 'persistent_params'
```

In your controller:

```ruby
class UsersController < ApplicationController
  persists_params
end
```

That's it. All the parameters except `controller` and `action` will be stored
and used between requests to the `index` action. If you want to apply to other
actions, use the `only` key when calling `persists_params`.

## HasScope Integration

In my case, I use the gem to save scopes defined by
[HasScope](https://github.com/plataformatec/has_scope). Not all parameters
are scopes, so I created a handy method that configures PersistentParams to
save only scopes:

```ruby
class UsersController < ApplicationController
  persists_params
end
```

## Clearing Params

To actually clear the previous params and prevent the redirecting, you need to
parameterize a `?clear=true`. I usually do this with a `link_to` in my `index`:

```erb
<%= link_to 'Clear Filters', users_path(clear: true) %>
```

## Contributing

* Fork
* Clone
* Create your branch
* Make your changes
* Push
* Create a Pull Request

## Copyright

Copyright (c) 2015 Diego Aguir Selzlein. See LICENSE.txt for further details.
