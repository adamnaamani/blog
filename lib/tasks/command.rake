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
end
