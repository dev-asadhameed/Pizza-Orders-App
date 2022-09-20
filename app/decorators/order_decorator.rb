class OrderDecorator
  attr_reader :order

  def initialize(data)
    @order = data.to_hash.with_indifferent_access
  end

  def uuid
    order[:id]
  end

  def created_at
    order[:createdAt].to_time.strftime(DATE_TIME_FORMAT)
  end

  def promotion_codes
    return '-' if order[:promotionCodes].none?
    
    order[:promotionCodes].join(', ')
  end

  def discount_code
    return '-' unless order[:discountCode]

    order[:discountCode]
  end

  def items
    order[:items]
  end

  def total_price
    "#{OrderPriceService.new(order).total_price.round(2)}$"
  end

  private

  DATE_TIME_FORMAT = '%B %d, %Y %H:%M'.freeze
  private_constant :DATE_TIME_FORMAT
end
