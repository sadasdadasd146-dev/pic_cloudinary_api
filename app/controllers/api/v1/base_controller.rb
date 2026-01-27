module Api::V1
  class BaseController < ApplicationController
    # ลบบรรทัดนี้ออกเพราะไม่จำเป็นสำหรับ API
    # skip_before_action :verify_authenticity_token
    
    before_action :set_default_response_format

    private
    def set_default_response_format
      request.format = :json
    end
  end
end