class Ahoy::Store < Ahoy::DatabaseStore
end

# set to true for JavaScript tracking
Ahoy.api = false

# set to true for geocoding (and add the geocoder gem to your Gemfile)
# we recommend configuring local geocoding as well
# see https://github.com/ankane/ahoy#geocoding
Ahoy.geocode = false

# Only track visits to existing blog posts
Ahoy.exclude_method = lambda do |controller, request|
  # For blog post URLs, check if the post exists
  if request.path.start_with?('/')
    slug = request.path[1..] # Remove leading slash
    return true unless Post.exists?(slug: slug)
  end

  true # Don't track any other URLs
end
