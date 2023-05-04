# Pipeline API gem

The Pipeline API gem is a ruby wrapper around the Pipeline API.  It will allow you full CRUD access to all of the core Pipeline components in a very easy-to-use library.

## Installation

Add this line to your application's Gemfile:

    gem 'pipeline'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pipeline

## Usage

First and foremost, authenticate your pipeline connection using one of the following methods:

```ruby
# api_key token based authentication:
pipeline = Pipeline.new(api_key: 'abcd1234', app_key: 'xxxxxxxxxxxxx')

# jwt_token based authentication:
pipeline = Pipeline.new(jwt: { token: 'abcd1234', expiration: time, refresh_token: 'abcd1234', refresh_expiration: time }, app_key: 'xxxxxxxxxxxxx')

# username/password based authentication (which will use jwt under the hood):
pipeline = Pipeline.new(username: 'abcd1234', password: 'abcd1234', app_key: 'xxxxxxxxxxxxx')
```

## Getting a single deal, person, or company:

```ruby
deal = pipeline.deals.find(1234)      # find the deal by id
deal.name = 'blah2'         # change an attribute
deal.save                   # re-save the deal to the site
deal.people                 # associations are respected
deal.people.first.id
deal.person_ids           
```

## Fetching collections of deals, people, or companies

```ruby
deals = pipeline.deals.find(:all)                                             # find(:all) is supported
deals = pipeline.deals.find(:all, params: {conditions: {deal_name: 'blah'}})
deals = pipeline.deals.where(conditions: {deal_name: 'blah'})
```

### Filtering

You can filter your list by adding a `conditions` parameter.  All
conditions are listed in the [Pipeline API documentation](https://www.pipelinecrm.com/api/docs)

```ruby
deals = pipeline.deals.where(conditions: {deal_value: {from: '500', to: '1000'}})
```

### Pagination

All list of things in the Pipeline API are paginated.  The default number of items per page is 200.

You can access the current page and total by calling `.pagination` on the list:

```ruby
deals = pipeline.deals.find(:all)
deals.pagination
=> {"per_page"=>200, "total"=>14, "page_var"=>"page", "pages"=>1, "page"=>1}
```

You can modify the page you are on when requesting:

```ruby
deals = pipeline.deals.find(:all, params: { page: 2})
# or you can use where
deals = pipeline.deals.where({page: 2})
```

You can modify the number per page as well:

```ruby
deals = pipeline.deals.where(per_page: 2, page: 3)
deals.pagination
=> {"per_page"=>3, "total"=>14, "page_var"=>"page", "pages"=>8, "page"=>2}
```

## Admin data

Admin data is currently read-only.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
