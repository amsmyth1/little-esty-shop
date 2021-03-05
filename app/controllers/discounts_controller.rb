class DiscountsController < ApplicationController
  def index
    @discounts = Discounts.all
  end
end
