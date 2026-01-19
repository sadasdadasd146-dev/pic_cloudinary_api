class MediaController < ApplicationController
  before_action :set_medium, only: %i[ show update destroy ]

  # GET /media
  def index
    @media = Medium.all

    render json: @media
  end

  # GET /media/1
  def show
    render json: @medium
  end

  # POST /media
  def create
    @medium = Medium.new(medium_params)

    if @medium.save
      render json: @medium, status: :created, location: @medium
    else
      render json: @medium.errors, status: :unprocessable_content
    end
  end

  # PATCH/PUT /media/1
  def update
    if @medium.update(medium_params)
      render json: @medium
    else
      render json: @medium.errors, status: :unprocessable_content
    end
  end

  # DELETE /media/1
  def destroy
    @medium.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_medium
      @medium = Medium.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def medium_params
      params.expect(medium: [ :user_id, :media_type, :url ])
    end
end
