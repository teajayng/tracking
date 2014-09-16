class TrackingNumbersController < ApplicationController
  respond_to :json

  before_filter :set_tracking_number, only: [:show, :update, :destroy]

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: {'errors' => ["record not found"]}, status: :not_found
  end

  # GET /tracking_numbers
  # GET /tracking_numbers.json
  def index
    respond_with TrackingNumber.all
  end

  # GET /tracking_numbers/1
  # GET /tracking_numbers/1.json
  def show
    if @tracking_number.info.instance_of?(ActiveMerchant::Shipping::TrackingResponse)# and @tracking_number.carrier != "FedEx"
      @tracking_number.update_track_info# unless @tracking_number.info.status_description == "DELIVERED"
    end
    respond_with @tracking_number
  end

  # POST /tracking_numbers
  # POST /tracking_numbers.json
  def create
    @tracking_number = TrackingNumber.new(tracking_number_params)

    respond_to do |format|
      if @tracking_number.save
        format.json { respond_with @tracking_number }
      else
        format.json { render json: @tracking_number.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tracking_numbers/1
  # PATCH/PUT /tracking_numbers/1.json
  def update
    respond_to do |format|
      if @tracking_number.update(tracking_number_params)
        format.html { redirect_to @tracking_number, notice: 'Tracking Number was successfully updated.' }
        format.json { render :show, status: :ok, location: @tracking_number }
      else
        format.html { render :edit }
        format.json { render json: @tracking_number.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tracking_numbers/1
  # DELETE /tracking_numbers/1.json
  def destroy
    @tracking_number.destroy
    respond_to do |format|
      format.html { redirect_to tracking_numbers_url, notice: 'Tracking Number was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tracking_number
      @tracking_number = TrackingNumber.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tracking_number_params
      params.require(:tracking_number).permit(:number)
    end
end
