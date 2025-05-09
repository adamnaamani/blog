class Ahoy::Store < Ahoy::DatabaseStore
end

# set to true for JavaScript tracking
Ahoy.api = false

# set to true for geocoding (and add the geocoder gem to your Gemfile)
# we recommend configuring local geocoding as well
# see https://github.com/ankane/ahoy#geocoding
Ahoy.geocode = false

# Skip tracking for sensitive URLs
Ahoy.exclude_method = lambda do |controller, request|
  sensitive_extensions = %w[yaml json php sql env]
  wp_content = %r{^/wp-content/}

  request.path =~ wp_content || sensitive_extensions.any? { |ext| request.path.end_with?(".#{ext}") }
end
