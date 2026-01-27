# lib/tasks/import_media.rake
namespace :import do
  desc "Import media from JSON file"
  task media: :environment do
    # รับพาธไฟล์จากอาร์กิวเมนต์
    file_path = ENV['FILE'] || 'import_data.json'
    
    unless File.exist?(file_path)
      puts "❌ ไม่พบไฟล์: #{file_path}"
      puts "ใช้งาน: rake import:media FILE=path/to/file.json"
      exit 1
    end
    
    puts "📖 อ่านไฟล์: #{file_path}"
    
    # อ่านไฟล์ JSON
    json_data = File.read(file_path)
    
    # นำเข้าข้อมูล
    puts "🚀 เริ่มนำเข้าข้อมูล..."
    results = MediaImporter.import_from_json(json_data)
    
    # แสดงผลลัพธ์
    puts "\n✅ นำเข้าเสร็จสิ้น!"
    puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    puts "📊 สถิติ:"
    puts "   รายการทั้งหมด: #{results[:total]}"
    puts "   นำเข้าสำเร็จ: #{results[:imported]}"
    puts "   ผู้ใช้ใหม่: #{results[:users_created]}"
    puts "   สื่อใหม่: #{results[:media_created]}"
    
    if results[:errors].any?
      puts "\n⚠️ ข้อผิดพลาด:"
      results[:errors].each do |error|
        puts "   - #{error[:user]}: #{error[:error]}"
      end
    else
      puts "\n✅ ไม่มีข้อผิดพลาด!"
    end
    
    puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  end
  
  desc "Import media from JSON string (for testing)"
  task :media_from_string, [:json_string] => :environment do |t, args|
    json_string = args[:json_string] || ENV['JSON']
    
    if json_string.nil?
      puts "❌ ต้องระบุ JSON string"
      puts "ใช้งาน: rake 'import:media_from_string[\"[{...}]\"]'"
      puts "หรือ: rake import:media_from_string JSON='[{...}]'"
      exit 1
    end
    
    puts "🚀 นำเข้าข้อมูลจาก JSON string..."
    results = MediaImporter.import_from_json(json_string)
    
    puts "\n✅ ผลลัพธ์:"
    puts results.to_json
  end
end