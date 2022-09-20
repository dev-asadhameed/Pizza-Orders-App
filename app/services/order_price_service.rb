class OrderPriceService
  attr_reader :order, :items, :promotion_codes, :discount_code

  class IncorrectOrderDetails < StandardError; end
  class InvalidPromotionCode < StandardError; end

  def initialize(data = {})
    @order = data.to_hash.with_indifferent_access
    @items = order[:items] || []
    @promotion_codes = order[:promotionCodes] || []
    @discount_code = order[:discountCode]
  end

  def total_price
    items_price - promotion_codes_price - discounted_price
  end

  private

  attr_reader :item, :item_base_price, :item_size_prize, :promotion_code

  CONFIG_FILE_PATH = 'app/data/config.yml'.freeze

  private_constant :CONFIG_FILE_PATH

  def add_ons_price
    item[:add].map do |add_on|
      raise IncorrectOrderDetails, 'Cannot find add on' unless config_file.dig(:ingredients, add_on)

      config_file.dig(:ingredients, add_on) * item_size_prize
    end.compact.sum
  end

  def calculate_promotion_code_price
    (promotional_items_count - no_of_times_promotion_code_can_be_applied - remaining_items_after_promotion_code_is_applied) * unit_promotional_item_price
  end

  def config_file
    @config_file ||= YAML.load_file(CONFIG_FILE_PATH).with_indifferent_access
  end

  def discounted_price
    return 0 unless config_file.dig(:discounts, discount_code)

    (items_price - promotion_codes_price) * (config_file.dig(:discounts, discount_code, :deduction_in_percent) / 100.to_f)
  end

  def items_price
    @items_price ||= begin
      items.map do |item|
        @item = item
        @item_base_price = config_file.dig(:pizzas, item[:name])
        @item_size_prize = config_file.dig(:size_multipliers, item[:size])

        validate_item

        unit_item_price + add_ons_price
      end.compact.sum
    end
  end

  def no_of_times_promotion_code_can_be_applied
    (promotional_items_count / promotion_code[:from]) * promotion_code[:to]
  end

  def promotion_codes_price
    @promotion_codes_price ||= begin
      promotion_codes.map do |pc|
        @promotion_code = config_file.dig(:promotions, pc)
        validate_promotion_code

        calculate_promotion_code_price
      end.compact.sum
    end
  end

  def promotional_items_count
    items.count { |item| item[:name] == promotion_code[:target] && item[:size] == promotion_code[:target_size] }
  end

  def remaining_items_after_promotion_code_is_applied
    promotional_items_count % promotion_code[:from]
  end

  def unit_item_price
    item_base_price.to_d * item_size_prize.to_d
  end

  def unit_promotional_item_price
    config_file.dig(:pizzas, @promotion_code[:target]) * config_file.dig(:size_multipliers, @promotion_code[:target_size])
  end

  def validate_item
    raise IncorrectOrderDetails, 'Item details are incorrect' unless valid_item?
  end

  def valid_item?
    item_base_price && item_size_prize
  end

  def validate_promotion_code
    raise InvalidPromotionCode, 'Invalid Promotion Code' unless promotion_code
  end
end
