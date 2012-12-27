module AccountsHelper
  def format_account(account)
    link_to "<span class=\"account_number\">#{account.number}</span> <span class=\"account_name\">#{account.name}</span>".html_safe, account
  end
end
