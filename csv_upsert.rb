require 'csv'

def import(file)
  unmatched = []
  CSV.foreach(file, headers: true) do |line|
    account = Account.where(name: line['number']).first
    if account
      account.update_attributes(Hash[line.select { |k,_| %(name kind).include?(k) }])
      puts account.to_s
      p line
    else
      unmatched << line
      account = Account.create!(Hash[line.select { |k,_| %(number name kind).include?(k) }])
    end
  end
  unmatched
end
