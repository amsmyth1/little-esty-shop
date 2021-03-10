class DiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @discounts = @merchant.discounts
    @holidays = HolidayService.next_three_holidays
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @discount = Discount.find(params[:id])
  end

  def edit
    @merchant = Merchant.find(params[:merchant_id])
    @discount = Discount.find(params[:id])
  end

  def update
    @merchant = Merchant.find(params[:merchant_id])
    @discount = @merchant.discounts.update(discount_params)[0]

    if @discount.save
      flash[:success] = "Your discount has been created!"
      redirect_to merchant_discount_path(@merchant, @discount)
    else
      flash[:error] = "Name cannot be blank. Threshold must be greater than 1.
      Percentage must be between 0 and 1."
      render :edit
    end
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
    @discount = @merchant.discounts.new
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    @discount = @merchant.discounts.new(
                                name: discount_params[:name],
                                threshold: discount_params[:threshold],
                                percentage: discount_params[:percentage]
                              )
    if @discount.save
      flash[:success] = "Your discount has been created!"
      redirect_to merchant_discounts_path(@merchant)
    else
      flash[:error] = "Name cannot be blank. Threshold must be greater than 1.
      Percentage must be between 0 and 1."
      render :new
    end
  end

  def destroy
    merchant = Merchant.find(params[:merchant_id])
    discount = Discount.find(params[:id])
    discount.destroy

    redirect_to merchant_discounts_path(merchant)
  end

  private
  def discount_params
    params.permit(:name, :threshold, :percentage)
  end
end
