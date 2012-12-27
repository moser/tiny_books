# encoding: utf-8
module ApplicationHelper
  def format_currency(value)
    number_to_currency(value)
  end
end
