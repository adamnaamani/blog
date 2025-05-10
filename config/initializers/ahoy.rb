class Ahoy::Store < Ahoy::DatabaseStore
end

# Enable JavaScript tracking
Ahoy.api = true

# Track visits immediately
Ahoy.track_visits_immediately = true

# set to true for geocoding (and add the geocoder gem to your Gemfile)
# we recommend configuring local geocoding as well
# see https://github.com/ankane/ahoy#geocoding
Ahoy.geocode = false

# Track all blog posts and exclude assets/non-blog content
Ahoy.exclude_method = lambda do |controller, request|
  # Skip if the path has a file extension (assets) or query parameters
  return true if request.path.include?('.') || request.query_string.present?

  # Track all blog post URLs
  if request.path.start_with?('/')
    slug = request.path[1..] # Remove leading slash
    return false if Post.exists?(slug: slug) # Track if it's a blog post
  end

  true # Don't track any other URLs
end
