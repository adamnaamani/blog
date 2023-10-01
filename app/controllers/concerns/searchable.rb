module Searchable
  extend ActiveSupport::Concern

  included do
    helper_method :json_ld, :seo_tags, :canonical_tag

    def seo(**args)
      @post = args[:post]
    end

    def title(args = nil)
      @title = [args.presence, I18n.t('seo.title')].reject(&:blank?).join(" | ")
    end

    def description(args = nil)
      @description = args.presence || I18n.t('seo.description')
    end

    def breadcrumb_schema
      {
        '@context': I18n.t('seo.context'),
        '@type': 'BreadcrumbList',
        itemListElement: [
          {
            '@type': 'ListItem',
            'position': 1,
            'name': '',
            'item': ''
          },
          {
            '@type': 'ListItem',
            'position': 2,
            'name': '',
            'item': ''
          }
        ]
      }
    end

    def default_schema
      {
        '@context': I18n.t('seo.context'),
        name: I18n.t('seo.title'),
        description: I18n.t('seo.description')
      }
    end

    def blog_posting_schema
      {
        "@context": "https://schema.org",
        "@type": "BlogPosting",
        url: request.original_url,
        mainEntityOfPage: request.original_url,
        headline: @post.title,
        name: @post.title,
        description: @post.description,
        image: [],
        datePublished: @post.published_date,
        dateModified: @post.updated_at,
        author: [{
            "@type": "Person",
            "name": I18n.t('name'),
            "url": I18n.t('website')
          }]
      }
    end

    def json_ld
      if action_name == 'index'
        render html: "<script type='application/ld+json'>#{default_schema.to_json}</script>".html_safe
      elsif action_name == 'show'
        render html: "<script type='application/ld+json'>#{blog_posting_schema.to_json}</script>".html_safe
      else
        render html: "<script type='application/ld+json'>#{default_schema.to_json}</script>".html_safe
      end
    end

    def seo_tags
      render partial: 'partials/seo'
    end

    def canonical_tag
      if controller_name == 'posts' && action_name == 'show'
        [request.base_url, @post.slug].join('/') if @post.present?
      else
        url_for(only_path: false, protocol: 'https')
      end
    end
  end
end
