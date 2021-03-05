class DiscountsController < ApplicationController
  def index
    @discounts = Discount.all
    @merchant = @discounts.first.merchant
  end

  def show
  end 
end
