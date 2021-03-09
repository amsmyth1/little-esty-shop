class InvoicesController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @invoices = @merchant.invoices.distinct
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    invoice_id = params[:id]
    @invoice = Invoice.find(invoice_id)
    @invoice_items = InvoiceItem.find_all_by_invoice(invoice_id)
    @discounts = Discounts.where(id: [Invoice.ii_and_associated_discounts(invoice_id)])
    @discounts.count > 0

  end
end
