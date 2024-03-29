class Cart
  attr_reader :contents, :coupon

  def initialize(contents, coupon)
    @contents = contents || {}
    @contents.default = 0
    @coupon = coupon || {}
  end

  def add_item(item_id)
    @contents[item_id] += 1
  end

  def less_item(item_id)
    @contents[item_id] -= 1
  end

  def count
    @contents.values.sum
  end

  def items
    @contents.map do |item_id, _|
      Item.find(item_id)
    end
  end

  def grand_total
    grand_total = 0.0
    @contents.each do |item_id, quantity|
      grand_total += Item.find(item_id).price * quantity
    end
    grand_total
  end

  def count_of(item_id)
    @contents[item_id.to_s]
  end

  def subtotal_of(item_id)
    @contents[item_id.to_s] * Item.find(item_id).price
  end

  def limit_reached?(item_id)
    count_of(item_id) == Item.find(item_id).inventory
  end

  def discounted_total
    coupon = Coupon.find(@coupon["coupon_id"])
    grand_total - coupon.amount
  end

  def apply_coupon(coupon)
    @coupon["coupon_id"] = coupon.id
  end
end
