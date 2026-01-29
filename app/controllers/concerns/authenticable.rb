module Authenticable
  extend ActiveSupport::Concern

  def authenticate_request
    token = extract_token
    Rails.logger.debug("Extracted token: #{token.present? ? 'present' : 'blank'}")
    Rails.logger.debug "RAW AUTH HEADER => #{request.headers['Authorization'].inspect}"
    Rails.logger.debug "RAW TOKEN => #{extract_token.inspect}"


    return render json: { success: false, message: 'Token required' }, status: :unauthorized if token.blank?

    decoded = JWT.decode(
      token,
      Rails.application.secret_key_base,
      true,
      algorithm: 'HS256'
    )[0]

    @current_user = User.find_by(id: decoded['user_id'])
    return render json: { success: false, message: 'User not found' }, status: :unauthorized unless @current_user

  rescue JWT::ExpiredSignature
    render json: { success: false, message: 'Token expired' }, status: :unauthorized
  rescue JWT::DecodeError
    render json: { success: false, message: 'Invalid token' }, status: :unauthorized
  end













  private

  def extract_token
    header = request.headers['Authorization']
    return nil if header.blank?

    parts = header.split(' ')
    return nil unless parts.length == 2 && parts.first.casecmp('Bearer').zero?

    parts.last
  end

  public

  def current_user
    @current_user
  end

  def authorize_admin!
    render json: { success: false, message: 'Admin access required' }, status: :forbidden unless current_user&.admin?
  end
end



