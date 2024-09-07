module PostsHelper
  def post_image_alt(image)
    return unless image.present?

    image.filename.to_s.rpartition(".").first.titleize
  end
end
