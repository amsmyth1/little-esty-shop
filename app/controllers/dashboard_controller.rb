class DashboardController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @top_five_customers = @merchant.top_five_customers
    @items_ready_to_ship = @merchant.invoice_items_ready
  end
end
