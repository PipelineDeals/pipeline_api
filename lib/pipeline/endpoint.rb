# frozen_string_literal: true

require "pipeline/base"

# Generic accessor for p.core endpoints the typed resource classes don't cover —
# notably internal endpoints outside the /api/v3 prefix (e.g.
# /api/internal/phone_lookup). Reuses Base's authentication (common_query /
# common_headers) and error handling so callers don't reimplement them. `path`
# is taken relative to the host root, not the /api/v3 prefix.
class Pipeline::Endpoint < Pipeline::Base
  def get(path, query: {}, headers: {})
    handle_errors(HTTParty.get("#{pipeline.url}#{path}", query: query.merge(common_query), headers: headers.merge(common_headers)))
  end
end
