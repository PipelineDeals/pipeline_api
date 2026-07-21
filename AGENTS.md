# AGENTS.md

Context file for agents and developers working in this repo.

## What this is

This repo builds the `pipeline` Ruby gem (repo name `pipeline_api`, gem name `pipeline`): a client
wrapper around the public Pipeline CRM REST API at `https://api.pipelinecrm.com/api/v3`. It gives
CRUD access to core Pipeline objects (deals, people, companies, notes, calendar entries, admin
settings, etc.) with pagination, dirty tracking, and typed exceptions. It is a library, not a
service — there is no server, database, or background worker here. Consumers are external API
integrators and internal tooling that talks to p.core over the public API.

## Setup

```sh
bundle install
```

- CI runs on `cimg/ruby:3.2.0`; `.rubocop.yml` targets Ruby 3.2.2. The gemspec's
  `required_ruby_version >= 2.2.0` is a compatibility floor, not what we develop against.
- Runtime dependencies are just `activesupport` and `httparty` (see `pipeline_api.gemspec`).
- Release: standard `bundler/gem_tasks` (`rake build` / `rake release`). Version lives in
  `pipeline_api.gemspec` (`gem.version`).

## Tests

CI (`.circleci/config.yml`, `rspec` job) runs the suite as:

```sh
bundle exec rspec --format progress
```

Locally:

```sh
bundle exec rspec                                  # full suite (also: `rake spec`, the default rake task)
bundle exec rspec spec/pipeline/people_spec.rb     # single file
bundle exec rspec spec/pipeline/people_spec.rb:12  # single example by line
```

- SimpleCov (branch coverage) is enabled only when `CI` or `TEST_REPORTER` is set (`spec/spec_helper.rb`).
- Specs are HTTP-recorded with VCR + WebMock. Cassettes live in `spec/cassettes/`, with
  `default_cassette_options = { record: :new_episodes }`. The global `cassette("suffix")` helper in
  `spec/spec_helper.rb` builds cassette names as `#{described_class}_suffix`.
- Because of `record: :new_episodes`, a spec whose request doesn't match an existing cassette will
  attempt a real HTTP call and record it — if a spec hangs or fails oddly offline, check for a
  missing/mismatched cassette rather than assuming a code bug.

## Lint

CI (`rubocop` job) runs RuboCop only against changed lines vs master, via the vendored wrapper:

```sh
./script/dirty_cop --circleci   # what CI runs
./script/dirty_cop --branch     # local: check changes in current branch
./script/dirty_cop --uncommitted
bundle exec rubocop lib/pipeline/foo.rb   # plain rubocop on a specific file
```

Style highlights from `.rubocop.yml`: double-quoted strings, max line length 160,
`frozen_string_literal: true` in every file, `rubocop-rspec` enabled. There is no brakeman or
bundle-audit job in this repo's CI.

## Architecture

```
lib/pipeline.rb            # Pipeline client class: auth state + one accessor per API resource
lib/pipeline/base.rb       # HTTParty verbs (_get/_post/_put/_patch/_delete), auth params/headers, error handling
lib/pipeline/collection.rb # Chainable query object: where/order/find/create/first/each/all + pagination;
                           # all Collection subclasses defined as one-liners at the bottom
lib/pipeline/resource.rb   # Record object: attribute hash via method_missing, dirty tracking (@changes),
                           # save sends only changed keys; all Resource subclasses defined at the bottom
lib/pipeline/endpoint.rb   # Raw GET access to paths outside /api/v3 (e.g. /api/internal/phone_lookup)
lib/pipeline/exceptions.rb # HTTP status -> exception mapping (table in README.md)
lib/pipeline/user.rb       # JWT authenticate/renew/revoke
lib/pipeline/import.rb     # Import resource with custom collection name
lib/pipeline/admin/feature.rb # Admin feature flags (add_provider/remove_provider)
```

Key patterns:

- **Class hierarchy**: `Pipeline::Base` handles HTTP + auth; `Pipeline::Collection` and
  `Pipeline::Resource` subclass it. Concrete classes (`Pipeline::Deal`, `Pipeline::People`,
  `Pipeline::Admin::DealStages`, ...) are `Class.new(Pipeline::Resource)` /
  `Class.new(Pipeline::Collection)` one-liners; endpoint paths are derived from the class name
  (`Pipeline::Base#initialize` underscores/pluralizes it, and `::Admin::` classes get an `/admin`
  URL prefix).
- **Adding a resource** means three edits: a `Class.new(Pipeline::Resource)` line in
  `resource.rb`, a `Class.new(Pipeline::Collection)` line in `collection.rb`, and an accessor
  method on `Pipeline` in `lib/pipeline.rb`. Add a spec plus VCR cassettes for
  index/create/delete (see any `spec/pipeline/admin/*_spec.rb` for the template).
- **Auth**: JWT bearer token is preferred when present; otherwise `api_key`/`app_key`
  (and optionally `account_key`) are sent as query params (`Base#common_query` /
  `#common_headers`). `Pipeline#authenticate` does the JWT login flow.
- **Dirty tracking**: `Resource#save` PUTs/POSTs only `@changes` keys. Writable attributes can be
  restricted per class via `writable_attributes`; writing anything else raises.
- **Errors**: every response passes through `Base#handle_errors`, raising
  `Pipeline::Exceptions::*` per status code. Client code is expected to rescue these:

  | Status | Exception |
  | --- | --- |
  | 400 | `Pipeline::Exceptions::BadRequestError` |
  | 401 | `Pipeline::Exceptions::NotAuthorizedError` |
  | 403 | `Pipeline::Exceptions::PermissionDeniedError` |
  | 404 | `Pipeline::Exceptions::NotFoundError` |
  | 406 | `Pipeline::Exceptions::NotAcceptableError` |
  | 429 | `Pipeline::Exceptions::TooManyRequestsError` |
  | 500 | `Pipeline::Exceptions::InternalPipelineError` |
  | other 3xx/4xx/5xx | `Pipeline::Exceptions::ApiError` (has a `code` attribute) |
- **Pagination**: `Collection#each`/`#map` fetch one page (default 200) at a time; `#all` loads
  everything into an array.

## Docs

- `README.md` — usage, auth flows, filtering, pagination, exception table, contribution flow.
- API reference for available `where` conditions: https://app.pipelinecrm.com/api/docs
