# app/controllers/api/v1/import_controller.rb
module Api
  module V1
    class ImportController < ApplicationController
      # POST /api/v1/import/media
      def media
        # ตรวจสอบว่ามีไฟล์หรือไม่
        if params[:file].present?
          # นำเข้าจากไฟล์
          file = params[:file]
          json_data = file.read
        elsif params[:data].present?
          # นำเข้าจากพารามิเตอร์ data
          json_data = params[:data]
        else
          # นำเข้าจาก body
          json_data = request.body.read
        end
        
        # ตรวจสอบว่ามีข้อมูลหรือไม่
        if json_data.blank?
          render json: { 
            error: 'No data provided. Please provide file, data parameter, or JSON body' 
          }, status: :bad_request
          return
        end
        
        # นำเข้าข้อมูล
        begin
          results = MediaImporter.import_from_json(json_data)
          
          # ตรวจสอบว่ามีข้อผิดพลาดหรือไม่
          if results[:errors].any?
            render json: {
              success: false,
              message: "Import completed with errors",
              results: results
            }, status: :partial_content
          else
            render json: {
              success: true,
              message: "Import completed successfully",
              results: results
            }, status: :ok
          end
        rescue JSON::ParserError => e
          render json: { 
            error: 'Invalid JSON format', 
            details: e.message 
          }, status: :bad_request
        rescue => e
          render json: { 
            error: 'Import failed', 
            details: e.message 
          }, status: :internal_server_error
        end
      end

      # POST /api/v1/import/assets
      def assets
        file = params[:file]
        creator_id = params[:creator_id]

        if file.blank? || creator_id.blank?
          return render json: {
            success: false,
            message: 'File and creator_id are required'
          }, status: :bad_request
        end

        begin
          creator = Creator.find(creator_id)
          imported_count = 0

          # Parse CSV or JSON
          case File.extname(file.original_filename)
          when '.csv'
            imported_count = import_from_csv(file, creator)
          when '.json'
            imported_count = import_from_json(file, creator)
          else
            raise 'Unsupported file format. Use CSV or JSON.'
          end

          render json: {
            success: true,
            message: "#{imported_count} assets imported successfully",
            data: {
              imported_count: imported_count
            }
          }, status: :created
        rescue => e
          render json: {
            success: false,
            message: e.message
          }, status: :unprocessable_entity
        end
      end

      private

      def import_from_csv(file, creator)
        count = 0
        CSV.foreach(file.path, headers: true) do |row|
          Asset.create(
            creator_id: creator.id,
            url: row['url'],
            cloudinary_id: row['cloudinary_id'],
            title: row['title'],
            description: row['description']
          )
          count += 1
        end
        count
      end

      def import_from_json(file, creator)
        count = 0
        data = JSON.parse(File.read(file.path))
        
        data.each do |item|
          Asset.create(
            creator_id: creator.id,
            url: item['url'],
            cloudinary_id: item['cloudinary_id'],
            title: item['title'],
            description: item['description']
          )
          count += 1
        end
        count
      end
    end
  end
end