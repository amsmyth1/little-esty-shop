class DiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @discounts = @merchant.discounts
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @discount = Discount.find(params[:id])
  end

  def destroy
    merchant = Merchant.find(params[:merchant_id])
    discount = Discount.find(params[:id])
    discount.destroy

    redirect_to merchant_discounts_path(merchant)
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
    @discount = @merchant.discounts.new
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    # new_merchant_id = (Discount.maximum(:id) + 1)

    # @discount = @merchant.discounts.new(discount_params.merge({id: new_merchant_id}))
    @discount = @merchant.discounts.new(discount_params)
    if @discount.save
      flash[:success] = "Your discount has been created!"
      redirect_to merchant_discounts_path(@merchant)
    else
      flash[:error] = "Name cannot be blank. Threshold must be greater than 1.
      Percentage must be between 0 and 1."
      render :new
    end
  end

  private
  def discount_params
    params.permit(:name, :threshold, :percentage)
  end
end
