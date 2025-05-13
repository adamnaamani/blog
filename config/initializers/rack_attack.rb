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
    [ 403, { "Content-Type" => "text/plain" }, [ "Forbidden" ] ]
  end

  # Throttle all requests by IP (60rpm)
  throttle("req/ip", limit: 60, period: 1.minute) do |req|
    req.ip
  end

  # Throttle subscriber creation by IP (5 per hour)
  throttle("subscribers/ip", limit: 5, period: 1.hour) do |req|
    if req.path == "/subscribers" && req.post?
      req.ip
    end
  end

  # Throttle subscriber creation by email domain (10 per hour)
  throttle("subscribers/domain", limit: 10, period: 1.hour) do |req|
    if req.path == "/subscribers" && req.post?
      email = req.params["subscriber"]["email"]
      email.split("@").last if email
    end
  end

  # Block suspicious requests
  blocklist("block suspicious requests") do |req|
    Rack::Attack::Allow2Ban.filter(req.ip, maxretry: 5, findtime: 1.hour, bantime: 24.hours) do
      req.path == "/subscribers" && req.post? && req.params["subscriber"]["email"].to_s.include?("spam")
    end
  end

  # Log blocked requests
  self.blocklisted_responder = lambda do |env|
    [ 403, { "Content-Type" => "text/plain" }, ["Blocked\n"] ]
  end
end
