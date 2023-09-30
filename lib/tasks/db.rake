namespace :db do
  require 'csv'

  desc 'Run database command'
  task run: :environment do
    file_location = Rails.root.join('posts.json')
    file = File.read(file_location)
    object = JSON.parse(file)
    posts = object['rss']['channel']['item']

    posts.each do |post|
      attributes = {
        post_id: post['post_id'],
        title: post['title']['__cdata'],
        slug: post['post_name']['__cdata'],
        meta: post['postmeta'].map { |k, v| { k['meta_key']['__cdata'] => k['meta_value']['__cdata'] } },
        published_date: post['pubDate'],
        content: post['encoded'][0]['__cdata']
      }
      Post.transaction do
        Post.create(attributes)
      end
    end
  end
end
