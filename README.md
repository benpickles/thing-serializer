# ThingSerializer

[![Build Status](https://travis-ci.org/benpickles/thing-serializer.svg?branch=master)](https://travis-ci.org/benpickles/thing-serializer)

A not very clever object serializer.

## Example

```ruby
class CategorySerializer
  include ThingSerializer::Base

  # Let the serializer generate Rails URLs, don't include it if you don't need
  # to generate URLs (but you probably should).
  include Rails.application.routes.url_helpers

  # `attribute` / `attributes` first look for a matching method on the
  # serializer and then its `object`.
  attributes :_embedded, :_links
  attributes :id, :name

  def _embedded
    {
      products: products,
    }
  end

  def _links
    {
      self: {
        href: category_url(object),
      },
    }
  end

  private
    # Access a serializer's `object` to define associations and other
    # non-standard attributes.
    def products
      # Easily map objects to serializers with `.to_proc`.
      object.products.map(&ProductSerializer)
    end
end

class ProductSerializer
  include ThingSerializer::Base
  include Rails.application.routes.url_helpers

  attribute :_links
  attributes :id, :name, :price

  def _links
    {
      self: {
        href: product_url(object),
      },
    }
  end
end
```

Use a serializer by instantiating it with a relevant object, generate JSON from a Rails controller like so:

```ruby
class CategoriesController < ApplicationController
  def show
    category = Category.find(params[:id])
    render json: CategorySerializer.new(category)
  end
end
```

(Assuming the following models:)

```ruby
class Category < ApplicationRecord
  has_many :products
end

class Product < ApplicationRecord
  belongs_to :category
end
```
