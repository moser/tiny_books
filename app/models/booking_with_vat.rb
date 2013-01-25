class BookingWithVat
  include ActiveModel::Validations
  extend ActiveModel::Naming

  Attrs = [ :vat_percentage, :vat_on_input, 
            :from_account_id, :to_account_id, :vat_account_id, :value_f, :text,
            :booking_date, :voucher_number, :business_year_id ]

  attr_accessor :parent_booking, :child_booking
  attr_accessor *Attrs

  validates_presence_of :business_year_id
  validates_presence_of :booking_date
  validates_presence_of :from_account_id
  validates_presence_of :to_account_id
  validates_presence_of :text
  validates_presence_of :value_f
  validates_presence_of :voucher_number
  validates_presence_of :vat_account_id
  validates_presence_of :vat_percentage

  def initialize(attrs = {})
    @voucher_number = Booking.last_voucher_number
    @parent_booking = Booking.new
    @child_booking = Booking.new
    @booking_date = Date.today
    @vat_percentage = 0.19
    @vat_on_input = true
    @vat_account_id = Account.where(name: "VSt").first.try(:id)
    @value_f = 0.0
    Attrs.each do |attr|
      self.send("#{attr}=", attrs[attr]) if attrs.has_key?(attr)
    end
  end

  def persisted?
    @parent_booking.persisted? && @child_booking.persisted?
  end

  def to_param
    @parent_booking.to_param
  end

  def to_key
    @parent_booking.to_key
  end

  def to_partial_path
    @parent_booking.to_partial_path
  end
  
  def vat_percentage=(f)
    f = f.to_f if f && f.respond_to?(:to_f)
    @vat_percentage = f
  end
  
  def value_f=(f)
    f = f.to_f if f && f.respond_to?(:to_f)
    @value_f = f
  end

  def save
    if valid?
      value = @value_f / (1.0 + @vat_percentage)
      vat = @value_f - value
      unless @vat_on_input
        child_to_account_id = @vat_account_id
        child_from_account_id = @from_account_id
      else
        child_to_account_id = @to_account_id
        child_from_account_id = @vat_account_id
      end
      @parent_booking = Booking.create(business_year_id: @business_year_id, booking_date: @booking_date, from_account_id: @from_account_id,
                                       to_account_id: @to_account_id, text: @text, value_f: value,
                                       voucher_number: @voucher_number)
      @child_booking = Booking.create(business_year_id: @business_year_id, booking_date: @booking_date, from_account_id: child_from_account_id,
                                       to_account_id: child_to_account_id, text: @text, value_f: vat,
                                       voucher_number: @voucher_number, parent_booking: @parent_booking)
    else
      false
    end
  end


  def self.l(sym = nil)
    if sym
      human_attribute_name(sym)
    else
      model_name.human
    end
  end

end
