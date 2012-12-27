require "spec_helper"

describe AccountsHelper do
  describe "#format_account" do
    it "produces some html" do
      account = FG.create(:account)
      helper.format_account(account).should match(/<a.*#{account_path(account)}.*#{account.number}.*#{account.name}.*/)
    end
  end
end
