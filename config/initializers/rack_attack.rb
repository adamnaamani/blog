class Rack::Attack
  # Block sensitive URLs
  blocklist("block sensitive urls") do |req|
    sensitive_extensions = %w[yaml json php sql env]
    wp_content = %r{^/wp-content/}

    if req.path =~ wp_content || sensitive_extensions.any? { |ext| req.path.end_with?(".#{ext}") }
      Rails.logger.warn "Rack Attack blocked access to sensitive URL: #{req.path}"
      true
    else
      false
    end
  end

  # Customize the response for blocked requests
  self.blocklisted_responder = lambda do |env|
    [403, { 'Content-Type' => 'text/plain' }, ['Forbidden']]
  end
end
