# app/controllers/api/v1/import_controller.rb
module Api::V1
  class ImportController < BaseController
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
  end
end