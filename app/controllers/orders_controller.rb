class OrdersController < ActionController::Base
  def index
    @orders = open_orders.map { |order| OrderDecorator.new(order) }
  end

  def update
    complete_order!

    respond_to do |format|
      format.html { redirect_to root_path }
      format.js
    end
  end

  private

  def complete_order!
    read_file.each do |order|
      order['state'] = 'COMPLETED' if order['id'] == params[:id]
    end

    write_file(read_file)
  end

  def open_orders
    @open_orders ||= read_file.map { |order| order if order['state'] == 'OPEN' }.compact
  end

  def read_file
    @read_file ||= JSON.parse(File.read('app/data/orders.json'))
  end

  def write_file(data)
    File.open("app/data/orders.json", "w+") do |f| 
      f.write(JSON.pretty_generate(data))
    end
  end
end
