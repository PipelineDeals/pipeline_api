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

### Token-based Authentication

If you are using an api_key token to authenticate with the API, you should have both an app_key and an api_key. The app_key can be created by an account admin [using the API integrations page](https://app.pipelinecrm.com/admin/modern/api). The api_key can be found for a user on [the API keys page](https://app.pipelinecrm.com/admin/modern/keys_api). In order to use your api_key, the app_key must be setup to allow api_key authentication.

Once you have your app_key and api_key, you configure the Pipeline gem to use these as follows:
```ruby
Pipeline.configure do |config|
  config.api_key = 'abcd1234'
  config.app_key = 'xxxxxxxxxxxxx'
end
```

### JWT-based Authentication

You will still need to set up an app_key, but you will need to ensure it is configured to allow JWT authentication.

Once you have your app_key, you can login to the API as follows:
```ruby
Pipeline.configure do |config|
  config.app_key = 'xxxxxxxxxxxxx'
end
# Note the MFA Code can be set to `nil` if it is not required...
Pipeline::Auth.authenticate("your@email.com", "yourpassword", "MFA Code (if reqiured)")
```

This will return a reference to the Pipeline::User that just logged in. And, the Authentication bearer token will automatically be set up for future API calls.

Once authentication is configured using either api_key or JWT, the following API calls can be made.

## Getting a single deal, person, or company:

```ruby
deal = Pipeline::Deal.find(1234)      # find the deal
deal.name = 'blah2'         # change an attribute
deal.save                   # re-save the deal to the site
deal.people                 # associations are respected
deal.people.first.id
deal.person_ids           
```

## Fetching collections of deals, people, or companies

```ruby
deals = Pipeline::Deal.find(:all)                                             # find(:all) is supported
deals = Pipeline::Deal.find(:all, params: {conditions: {deal_name: 'blah'}})
deals = Pipeline::Deal.where(conditions: {deal_name: 'blah'})
```

### Filtering

You can filter your `find` or `where` call by adding a `conditions` parameter as shown above.  All
available conditions are listed in the [Pipeline API documentation](https://www.pipelinecrm.com/api/docs)

```ruby
deals = Pipeline::Deal.where(conditions: {deal_value: {from: '500', to: '1000'}})
```

### Pagination

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

## Admin data

Admin data is currently read-only.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
