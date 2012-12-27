class ActiveRecord::Base
  def self.l(sym = nil)
    if sym.nil?
      model_name.human
    else
      human_attribute_name(sym)
    end
  end
end
