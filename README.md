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

### JWT-based Authentication

You will still need to set up an app_key, but you will need to ensure it is configured to allow JWT authentication.

Once you have your app_key, you can login to the API as follows:
```ruby
pipeline = Pipeline.new

# Note the MFA Code can be set to `nil` if it is not required...
pipeline.authenticate(app_key: 'xxxxxxxxxx', email: "your@email.com", password: "yourpassword", mfa_code: "MFA Code (if reqiured)")
```

This will return a reference to the Pipeline::User that just logged in. And, the Authentication bearer token will automatically be set up for future API calls.

Once authentication is configured using JWT, API calls can be made from this `pipeline` client object.

### Token-based Authentication

If you are using an api_key token to authenticate with the API, you should have both an app_key and an api_key. The app_key can be created by an account admin [using the API integrations page](https://app.pipelinecrm.com/admin/modern/api). The api_key can be found for a user on [the API keys page](https://app.pipelinecrm.com/admin/modern/keys_api). In order to use your api_key, the app_key must be setup to allow api_key authentication. If you enable both JWT and api_key, the gem will prefer JWT-based authentication.

Once you have your app_key and api_key, you configure the Pipeline gem to use these as follows:
```ruby
pipeline = Pipeline.new(api_key: 'abcd1234', app_key: 'xxxxxxxxxxxxx')
```

or you can authenticate as with JWT:
```ruby
pipeline = Pipeline.new

# Note the MFA Code can be set to `nil` if it is not required...
pipeline.authenticate(app_key: 'xxxxxxxxxx', email: "your@email.com", password: "yourpassword", mfa_code: "MFA Code (if reqiured)")
```

Once authentication is configured using your api_key, API calls can be made from this `pipeline` client object.

## Authenticated User / Account

Using your authenticated `pipeline` client object, you can always get the authenticated user object:
```ruby
pipeline.user
```

You can also get the account of the authenticated user object:
```ruby
pipeline.account
```

## Reading and updating a single deals, people, or companies:

```ruby
deal = pipeline.deals.find(1234)      # find the deal
deal.name = 'blah2'                   # change an attribute
deal.save                             # save the deal updates
```

## Collections of deals, people, or companies:

Calling `pipeline.people` does not immediately query Pipeline for people. You have to follow that up with `all`, `each { |e| ... }` or `map { |e| ... }`.

Calling `pipeline.people.all` reads all pages of people, and returns an array of objects `Pipeline::Person`.

Calling `pipeline.people.each { |p| ... }` or `pipeline.people.map { |p| ... }` iterates through all the people, but it reads only one page at a time (like rails `find_each`).

```
pipeline.deals.where(deal_value: { from: 10, to: 1000 }).map(&:name)  # return names of deals with valuebetween 10 and 1000, inclusive.

people = pipeline.people.all                                          # all people in the account

pipeline.companies.each do |company|                                  # iterate through all companies (API pagination is handled, and only one page of records is in memory at a time)
  puts "company name: #{company.name}"
end
```

### Filtering collections:

```ruby
deals = pipeline.deals.where(deal_name: 'blah').all                # get all deals containing 'blah' (case-insensitive)
pipeline.deals.where(deal_name: 'blah').each { |d| puts d.name }   # iterate through matching deals
```

You can filter your `where` call by adding any of the `conditions` parameters available conditions
documented on each object in the [Pipeline API documentation](https://app.pipelinecrm.com/api/docs)

```ruby
deals = pipeline.deals.where(deal_value: {from: 500, to: 1000}).all
```

### Pagination

All lists of things in the Pipeline API are paginated.  The default number of items per page is 200. Pagination is handled by the gem for you.

## Admin data

Admin data can be read or written in the same way that other objects can be, but the user must be an account admin.

## Exceptions

Various return codes will raise exceptions as shown below. Your code should rescue and handle exceptions appropriately.

| Return Code | Exception                                    |
| ----------- | -------------------------------------------- |
| 400         | Pipeline::Exceptions::BadRequestError        |
| 401         | Pipeline::Exceptions::NotAuthorizedError     |
| 403         | Pipeline::Exceptions::PermissionDeniedError  |
| 404         | Pipeline::Exceptions::NotFoundError          |
| 406         | Pipeline::Exceptions::NotAcceptableError     |
| 429         | Pipeline::Exceptions::TooManyRequestsError   |
| 500         | Pipeline::Exceptions::InternalPipelineError  |
| 3XX 4XX 5XX | Pipeline::Exceptions::ApiError               |

The PipelineExceptions::ApiError object has a `code` attribute so you can see the precise error code.

```ruby
pipeline = Pipeline.new
begin
  user = pipeline.authenticate(app_key: 'xxxxxxxx', email: 'fake@email.com', password: 'wrong-password', mfa_code: 'bad code')
rescue Pipeline::Exceptions::NotAuthorizedError => e
  puts "failed authentication: #{e.message}"
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
