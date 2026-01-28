# app/services/media_importer.rb
require 'securerandom'
require 'uri'

class MediaImporter
  # =========================
  # Main import
  # =========================
  def self.import_from_json(json_data)
    data =
      case json_data
      when String
        JSON.parse(json_data)
      when Array
        json_data
      else
        []
      end

    results = {
      total: data.size,
      imported: 0,
      users_created: 0,
      assets_created: 0,
      errors: []
    }

    data.each do |item|
      ActiveRecord::Base.transaction do
        user_created, asset_count = import_item(item)

        results[:imported] += 1 if asset_count.positive?
        results[:users_created] += 1 if user_created
        results[:assets_created] += asset_count
      end
    rescue => e
      results[:errors] << {
        user: item['user'],
        error: e.message
      }
    end

    results
  end

  # =========================
  # Import 1 item
  # =========================
  def self.import_item(item)
    user, user_created = find_or_create_user(item['user'])

    asset_count = 0
    asset_count += import_assets(user, item['images'], 'image')
    asset_count += import_assets(user, item['videos'], 'video')

    [user_created, asset_count]
  end

  # =========================
  # User
  # =========================
  def self.find_or_create_user(username)
    raise 'Username is missing' if username.blank?

    username = username.strip
    user = User.find_by(username: username)
    return [user, false] if user

    password = SecureRandom.hex(16)

    user = User.create!(
      username: username,
      name: username,
      role: 'creator',
      avatar: "https://i.pravatar.cc/150?u=#{username.parameterize}",
      bio: 'User imported from Discord',
      is_verified: false,
      previews: [],
      password: password,
      password_confirmation: password
    )

    [user, true]
  end

  # =========================
  # Assets
  # =========================
  def self.import_assets(user, urls, media_type)
    return 0 unless urls.is_a?(Array)

    created = 0

    urls.each do |url|
      begin
        clean_url = sanitize_url(url)
        next if clean_url.blank?

        asset = Asset.find_or_create_by!(
          user: user,
          url: clean_url,
          media_type: media_type
        ) do |a|
          a.title          = generate_title(user.name, media_type, clean_url)
          a.tags           = generate_tags(media_type)
          a.upload_date    = Time.current
          a.author_name    = user.name
          a.author_avatar  = user.avatar
        end

        created += 1 if asset.saved_change_to_id?

      rescue ActiveRecord::RecordNotUnique
        next
      end
    end

    created
  end

  # =========================
  # Utils
  # =========================

  # ลบ cloudinary transformation แต่คง v123 ไว้
  def self.sanitize_url(url)
    return nil if url.blank?

    url = url.strip
    url.sub(
      %r{(/image/upload/)([^/]+/)(v\d+/)},
      '\1\3'
    )
  end

  # -------------------------
  # Generate title
  # -------------------------
  def self.generate_title(username, media_type, url = nil)
    base =
      if url.present?
        File.basename(URI.parse(url).path).split('.').first
      else
        SecureRandom.hex(4)
      end

    "#{username} - #{media_type} - #{base}"
  rescue
    "#{username} - #{media_type}"
  end

  # -------------------------
  # Generate tags
  # -------------------------
  def self.generate_tags(media_type)
    base_tags = %w[imported discord cloudinary]

    case media_type
    when 'image'
      base_tags + %w[photo image]
    when 'video'
      base_tags + %w[video clip]
    else
      base_tags
    end
  end
end


