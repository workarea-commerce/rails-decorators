# Rails::Decorators
Using [Rails engines](http://guides.rubyonrails.org/engines.html) extensively, we needed a way to customize behavior for implementations of the platform. Rails provides a great mechanism for views and assets, but doesn't offer any functionality to handle controller/model/lib overriding/customizing. The suggested mechanism in the documentation is `class_eval` or ActiveSupport::Concern. Our preferred method for this is module prepending, which is cleaner than `class_eval` in that it avoids alias method chaining and becomes part of the ancestor chain.

We also want junior developers to be able to jump in and be productive ASAP - not necessarily requiring they learn the techniques of `class_eval` to fix a bug or get a simple task done. Yes, we educate and promote this as the developer grows, but we want the barriers to contribution as low as possible.

We like the [`ActiveSupport::Concern`](http://api.rubyonrails.org/classes/ActiveSupport/Concern.html) API, so this library mimics the API of `ActiveSupport::Concern` and layers on top some niceties for the specific task of customizing a Rails engine. Also, we don't like having to store decorated behavior in a separate directory (like https://github.com/parndt/decorators). Storing decorations in the same place as new classes makes it much easier to see the overall picture of how the engine has been customized/extended in one shot.

## Usage
Say we have a class in an engine like so:
```ruby
# in ecommerce/app/models/ecommerce/product.rb
module Ecommerce
  class Product < ApplicationRecord
    def price
      skus.first.price
    end
  end
end
```

`Rails::Decorators` allows customizing this class like so:
```ruby
# in Rails.root/app/models/ecommerce/product.decorator
module Ecommerce
  decorate Product do
    decorated do
      # Class methods may be called here. Evaluates after prepending module.
      attr_writer :on_sale
    end

    class_methods do
      # Methods defined here extend/decorate static methods on the
      # decorated class.
      def sorts
        super + ['discount_rate']
      end
    end

    # Methods defined here extend/decorate instance methods on the
    # decorated class.
    def price
      result = super
      result *= discount_rate if on_sale?
      result
    end
  end
end
```

`Rails::Decorators` achieves this in a manner similar to `ActiveSupport::Concern` - it dynamically creates a module out of the block passed, and then prepends that into the original class. The above is equivalent to (note that this would need to be required as well):
```ruby
# in Rails.root/app/models/ecommerce/product_decorator.rb
module Ecommerce
  class Product
    module Decorator
      module ClassMethods
        # Methods defined here extend/decorate static methods on the
        # decorated class.
        def sorts
          super + ['discount_rate']
        end
      end

      # Methods defined here extend/decorate instance methods on the
      # decorated class.
      def price
        result = super
        result *= discount_rate if on_sale?
        result
      end
    end
  end

  Product.send(:prepend, Product::Decorator)
  Product.singleton_class.send(:prepend, Product::Decorator::ClassMethods)
  Product.class_eval do
    # Class methods may be called here. Evaluates after prepending module.
    attr_writer :on_sale
  end
end
```

You can also decorate more than one class at a time:
```ruby
# in Rails.root/app/models/ecommerce/navigable.decorator
module Ecommerce
  decorate Product, Category, Page do
    def generate_slug
      # my custom logic here
    end
  end
end
```

Other engines may want to namespace their customizations so as not to collide with further customizations:
```ruby
# in ecommerce_blog/app/models/ecommerce/product.decorator
module Ecommerce
  decorate Product, with: 'blog' do
    def blog_entries
      BlogEntry.for_product(id)
    end
  end
end
```

It is strongly suggested you update your editor of choice to use Ruby syntax highlighting on \*.decorator files.

### Case Study: Modifying Devise

Let's examine a more real-world case: In the [Devise OmniAuth How-To
Article](https://github.com/heartcombo/devise/wiki/OmniAuth:-Overview),
the maintainers instruct users to create a new controller named
`Users::OmniauthCallbacksController` that inherits from
`Devise::OmniauthCallbacksController`, and override the entire class in
the `devise_for` method by supplying the name of the controller to use.
This has always been a point of contention for some as it's quite
difficult to understand why you need to do this if you don't have a lot
of experience with Rails applications.

However, if you had `rails-decorators` installed, you don't need to do
any of that. Just decorate the controller supplied by Devise in
**app/controllers/devise/omniauth_callbacks_controller.decorator**!

```ruby
module Devise
  decorate OmniauthCallbacksController do
    # We're using Facebook as an example here so it can be directly
    # translated from the aforementioned article...
    def facebook
      # You need to implement the method below in your model (e.g. app/models/user.rb)
      @user = User.from_omniauth(request.env["omniauth.auth"])

      if @user.persisted?
        sign_in_and_redirect @user, event: :authentication #this will throw if @user is not activated
        set_flash_message(:notice, :success, kind: "Facebook") if is_navigational_format?
      else
        session["devise.facebook_data"] = request.env["omniauth.auth"]
        redirect_to new_user_registration_url
      end
    end

    def failure
      redirect_to root_path
    end
  end
end
```

With `rails-decorators`, you get to skip about 3 or 4 paragraphs of docs
and go right to the `.from_omniauth` definition. Decorating saves both
time and mental energy so you can get back to actually writing your
application.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'rails-decorators'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install rails-decorators
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
