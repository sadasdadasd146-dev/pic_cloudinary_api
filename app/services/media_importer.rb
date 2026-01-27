# app/services/media_importer.rb
class MediaImporter
  def self.import_from_json(json_data)
    data = JSON.parse(json_data) if json_data.is_a?(String)
    data = json_data if json_data.is_a?(Array)
    
    results = {
      total: data.size,
      imported: 0,
      users_created: 0,
      media_created: 0,
      errors: []
    }
    
    data.each do |item|
      begin
        import_item(item)
        results[:imported] += 1
        results[:users_created] += 1 if @user_created
        results[:media_created] += @media_count
      rescue => e
        results[:errors] << {
          user: item['user'],
          error: e.message
        }
      end
    end
    
    results
  end
  
  private
  
  def self.import_item(item)
    # 1. ค้นหาหรือสร้างผู้ใช้
    user = find_or_create_user(item['user'])
    
    # 2. นำเข้ารูปภาพ
    import_media(user, item['images'], 'image')
    
    # 3. นำเข้าวิดีโอ
    import_media(user, item['videos'], 'video')
  end
  
  def self.find_or_create_user(username)
    # ลบช่องว่างที่ไม่จำเป็น
    username = username.strip
    
    # ค้นหาผู้ใช้ที่มีอยู่แล้ว
    user = User.find_by(username: username)
    
    if user
      @user_created = false
      return user
    end
    
    # สร้างผู้ใช้ใหม่
    user = User.create!(
      username: username,
      name: username,
      role: 'creator',
      avatar: "https://i.pravatar.cc/150?u=#{username.parameterize}",
      bio: "User imported from Discord",
      is_verified: false,
      previews: []
    )
    
    @user_created = true
    user
  end
  
  def self.import_media(user, urls, media_type)
    @media_count = 0
    
    urls.each do |url|
      # ทำความสะอาด URL (ลบช่องว่างและพารามิเตอร์ที่ไม่จำเป็น)
      clean_url = sanitize_url(url)
      next if clean_url.blank?
      
      # ตรวจสอบว่ามีอยู่แล้วหรือไม่ (ป้องกันซ้ำ)
      next if Asset.exists?(url: clean_url, user_id: user.id, media_type: media_type)
      
      # สร้างสื่อใหม่
      Asset.create!(
        user: user,
        media_type: media_type,
        url: clean_url,
        title: generate_title(user.name, media_type),
        tags: generate_tags(media_type),
        upload_date: Time.current,
        author_name: user.name,
        author_avatar: user.avatar
      )
      
      @media_count += 1
    end
  end
  
  def self.sanitize_url(url)
    # ลบช่องว่างที่ปลาย
    url = url.strip
    
    # ลบพารามิเตอร์ที่ไม่จำเป็นจาก Discord URL
    # เช่น &ex=... &is=... &hm=... &=&format=webp&width=...&height=...
    url = url.gsub(/&ex=[^&]*/, '')
    url = url.gsub(/&is=[^&]*/, '')
    url = url.gsub(/&hm=[^&]*/, '')
    url = url.gsub(/&=&format=[^&]*/, '')
    url = url.gsub(/&width=[^&]*/, '')
    url = url.gsub(/&height=[^&]*/, '')
    
    # ลบเครื่องหมาย & ที่ซ้ำหรืออยู่ท้าย
    url = url.gsub(/&+/, '&').gsub(/&$/, '')
    
    url
  end
  
  def self.generate_title(username, media_type)
    type_name = media_type == 'image' ? 'รูปภาพ' : 'วิดีโอ'
    "#{type_name} โดย #{username} - #{Time.current.strftime('%Y-%m-%d %H:%M')}"
  end
  
  def self.generate_tags(media_type)
    if media_type == 'image'
      ['photo', 'discord', 'imported']
    else
      ['video', 'discord', 'imported']
    end
  end
end





