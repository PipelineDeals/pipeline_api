# Pipeline API gem

The Pipeline API gem is a ruby wrapper around the Pipeline API.  It will allow you full CRUD access to all of the core Pipeline components in a very easy-to-use library.

## Installation

Add this line to your application's Gemfile:

    gem 'pipeline'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pipeline

## Usage: Class-based Methodology

First and foremost, register your api key:

```ruby
Pipeline.configure do |config|
  config.api_key = 'abcd1234'
end
```

If you have an app_key, register this along with your api key:

```ruby
Pipeline.configure do |config|
  config.api_key = 'abcd1234'
  config.app_key = 'xxxxxxxxxxxxx'
end
```

### Getting a single deal, person, or company:

```ruby
deal = Pipeline::Deal.find(1234)      # find the deal
deal.name = 'blah2'         # change an attribute
deal.save                   # re-save the deal to the site
deal.people                 # associations are respected
deal.people.first.id
deal.person_ids
```

### Fetching collections of deals, people, or companies

```ruby
deals = Pipeline::Deal.find(:all)                                             # find(:all) is supported
deals = Pipeline::Deal.find(:all, params: {conditions: {deal_name: 'blah'}})
deals = Pipeline::Deal.where(conditions: {deal_name: 'blah'})
```

#### Filtering

You can filter your list by adding a `conditions` parameter.  All
conditions are listed in the [Pipeline API documentation](https://www.pipelinecrm.com/api/docs)

```ruby
deals = Pipeline::Deal.where(conditions: {deal_value: {from: '500', to: '1000'}})
```

#### Pagination

All list of things in the Pipeline API are paginated.  The default number of items per page is 200.

You can access the current page and total by calling `.pagination` on the list:

```ruby
deals = Pipeline::Deal.find(:all)
deals.pagination
=> {"per_page"=>200, "total"=>14, "page_var"=>"page", "pages"=>1, "page"=>1}
```

You can modify the page you are on when requesting:

```ruby
deals = Pipeline::Deal.find(:all, params: { page: 2})
# or you can use where
deals = Deal.where({page: 2})
```

You can modify the number per page as well:

```ruby
deals = Pipeline::Deal.where(per_page: 2, page: 3)
deals.pagination
=> {"per_page"=>3, "total"=>14, "page_var"=>"page", "pages"=>8, "page"=>2}
```

### Admin data

Admin data is currently read-only.

## Usage: `account` Object-based Methodology

First and foremost, authenticate your pipeline connection using one of the following methods:

```ruby
# api_key token based authentication:
account = Pipeline.authenticate(api_key: 'abcd1234', app_key: 'xxxxxxxxxxxxx')

# jwt_token based authentication:
account = Pipeline.authenticate(jwt: { token: 'abcd1234', expiration: time, refresh_token: 'abcd1234', refresh_expiration: time }, app_key: 'xxxxxxxxxxxxx')

# username/password based authentication (which will use jwt under the hood):
account = Pipeline.authenticate(username: 'abcd1234', password: 'abcd1234', app_key: 'xxxxxxxxxxxxx')

# account_key based authentication:
account = Pipeline.authenticate(account_key: 'abcd1234', app_key: 'xxxxxxxxxxxxx')
```

### Getting a single deal, person, or company:

```ruby
deal = account.deals.find(1234)      # find the deal by id
deal.name = 'blah2'         # change an attribute
deal.save                   # re-save the deal to the site
deal.people                 # associations are respected
deal.people.first.id
deal.person_ids           
```

### Fetching collections of deals, people, or companies

```ruby
deals = account.deals.find(:all)                                             # find(:all) is supported
deals = account.deals.find(:all, params: {conditions: {deal_name: 'blah'}})
deals = account.deals.where(conditions: {deal_name: 'blah'})
```

#### Filtering

You can filter your list by adding a `conditions` parameter.  All
conditions are listed in the [Pipeline API documentation](https://www.pipelinecrm.com/api/docs)

```ruby
deals = account.deals.where(conditions: {deal_value: {from: '500', to: '1000'}})
```

#### Pagination

All list of things in the Pipeline API are paginated.  The default number of items per page is 200.

You can access the current page and total by calling `.pagination` on the list:

```ruby
deals = account.deals.find(:all)
deals.pagination
=> {"per_page"=>200, "total"=>14, "page_var"=>"page", "pages"=>1, "page"=>1}
```

You can modify the page you are on when requesting:

```ruby
deals = account.deals.find(:all, params: { page: 2})
# or you can use where
deals = account.deals.where({page: 2})
```

You can modify the number per page as well:

```ruby
deals = account.deals.where(per_page: 2, page: 3)
deals.pagination
=> {"per_page"=>3, "total"=>14, "page_var"=>"page", "pages"=>8, "page"=>2}
```

### Admin data

Admin data is currently read-only.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
