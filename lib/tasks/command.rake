namespace :command do
  desc "Run database command"
  task run: :environment do
    file = URI.open("https://naamani.s3.ca-central-1.amazonaws.com/json/posts.json").read
    object = JSON.parse(file)
    posts = object["rss"]["channel"]["item"]

    posts.each do |post|
      attributes = {
        post_id: post["post_id"],
        title: post["title"]["__cdata"],
        slug: post["post_name"]["__cdata"],
        meta: post["postmeta"].map { |k, v| { k["meta_key"]["__cdata"] => k["meta_value"]["__cdata"] } },
        published_date: post["pubDate"],
        content: post["encoded"][0]["__cdata"]
      }
      Post.transaction do
        post = Post.find_or_initialize_by(post_id: attributes[:post_id])
        post.assign_attributes(attributes)
        post.save
      end
    end
  end

  desc "Run images command"
  task images: :environment do
    file = URI.open("https://naamani.s3.ca-central-1.amazonaws.com/json/media.json").read
    object = JSON.parse(file)
    images = object["rss"]["channel"]["item"]

    images = images.map do |image|
      {
        guid: image["guid"],
        published_date: image["pubDate"],
        post_id: image["post_id"],
        post_parent: image["post_parent"],
        post_name: image["post_name"]["__cdata"],
        filename: image["guid"].to_s.split("/")[-1]
      }
    end

    Post.find_each do |post|
      image = images.select { |i| i[:post_parent] == post.post_id }
      if image.present?
        image.each do |i|
          post.images.attach(
            io: URI.open(i[:guid]),
            filename: i[:filename]
          )
        end
      end
    end
  end

  desc "Purge unattached"
  task purge_unattached: :environment do
    ActiveStorage::Blob.unattached.find_each(&:purge)
  end

  desc "Export posts"
  task export_posts: :environment do
    posts = Post.published
                .order(created_at: :desc)
                .with_rich_text_content
                .map do |post|
                  {
                    tite: post.title,
                    post: ActionView::Base.full_sanitizer.sanitize(post.content.body.to_s),
                    published: post.published_date
                  }
                end

    File.write("posts.json", JSON.pretty_generate(posts))
  end

  desc "Clean up Ahoy entries that don't match valid paths"
  task cleanup_ahoy: :environment do
    dry_run = ENV["DRY_RUN"] == "true"
    puts "Running in #{dry_run ? 'DRY RUN' : 'LIVE'} mode"

    # Get all valid paths from routes
    valid_paths = [
      "/",                    # root
      "/blog",               # blog index
      "/drafts",             # drafts
      "/up",                 # health check
      "/users/sign_in",      # devise
      "/users/sign_out",     # devise
      "/users/password/new", # devise
      "/users/password",     # devise
      "/users/confirmation", # devise
      "/uploads",            # uploads
      "/nows",               # nows
      "/subscribers"         # subscribers
    ]

    # Add all post slugs
    post_slugs = Post.pluck(:slug)
    valid_paths += post_slugs

    puts "\nValid paths:"
    valid_paths.each { |path| puts "  - #{path}" }
    puts "\nTotal valid paths: #{valid_paths.count}"

    # Get all Ahoy visits
    visits = Ahoy::Visit.all
    puts "\nTotal visits: #{visits.count}"

    # Find visits with invalid paths
    invalid_visits = visits.select do |visit|
      # First check the landing page
      landing_page_invalid = if visit.landing_page.present?
        !valid_paths.any? { |valid_path| visit.landing_page.include?(valid_path) }
      else
        false
      end

      puts "\nChecking visit #{visit.id}"
      puts "  - Landing page: #{visit.landing_page} (#{landing_page_invalid ? 'invalid' : 'valid'})" if visit.landing_page.present?

      # Then check associated events
      events = Ahoy::Event.where(visit_id: visit.id)
      puts "  - Events: #{events.count}"

      events_invalid = events.any? do |event|
        # Extract path from properties
        path = if event.properties["path"].present?
          event.properties["path"]
        elsif event.properties["slug"].present?
          "/#{event.properties["slug"]}"
        elsif event.properties["controller"].present? && event.properties["action"].present?
          "/#{event.properties["controller"]}/#{event.properties["action"]}"
        end

        if path.present?
          is_valid = valid_paths.any? { |valid_path| path.start_with?(valid_path) }
          puts "    - Event path: #{path} (#{is_valid ? 'valid' : 'invalid'})"
          !is_valid
        else
          puts "    - No path found in event properties: #{event.properties.inspect}"
          false
        end
      end

      landing_page_invalid || events_invalid
    end

    # Show what would be deleted
    if invalid_visits.any?
      puts "\nInvalid visits found:"
      invalid_visits.each do |visit|
        puts "\nVisit #{visit.id}:"
        puts "  - Landing page: #{visit.landing_page}" if visit.landing_page.present?

        events = Ahoy::Event.where(visit_id: visit.id)
        events.each do |event|
          path = if event.properties["path"].present?
            event.properties["path"]
          elsif event.properties["slug"].present?
            "/#{event.properties["slug"]}"
          elsif event.properties["controller"].present? && event.properties["action"].present?
            "/#{event.properties["controller"]}/#{event.properties["action"]}"
          end
          puts "  - Event: #{path || 'No path'} (#{event.properties.inspect})"
        end
      end
    else
      puts "\nNo invalid visits found"
    end

    if dry_run
      puts "\nDRY RUN: Would delete #{invalid_visits.count} visits"
    else
      # Delete invalid visits and their events
      invalid_visits.each do |visit|
        puts "Deleting visit #{visit.id} with invalid paths"
        Ahoy::Event.where(visit_id: visit.id).delete_all
        visit.destroy
      end
      puts "\nCleaned up #{invalid_visits.count} invalid visits"
    end
  end
end
