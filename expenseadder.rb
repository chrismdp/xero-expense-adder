# encoding: utf-8
require 'xeroizer'
require 'yaml'
require 'simple_currency'

config = YAML.load(File.read("keys.yaml"))

client = Xeroizer::PrivateApplication.new(config['key'], config['secret'], "privatekey.pem")

me = client.Contact.find(config['contact'])

invoice = client.Invoice.build(:type => "ACCPAY")
invoice.contact = me

def convert_to_gbp(amount, currency, date)
  case currency
  when '$'
    return amount.to_f.usd.at(Time.parse(date)).to_gbp
  when '€'
    return amount.to_f.eur.at(Time.parse(date)).to_gbp
  end
  amount
end

total = 0
Dir[ARGV[0] + '/*.pdf'].each do |file|
  name = File.basename(file)
  whole, date, who, currency, amount = name.match(/(.*?) (.*?) (£|\$|€)(.*?)\.pdf/).to_a

  converted_amount = convert_to_gbp(amount, currency, date)

  puts "Adding line item for #{who}: spent #{currency}#{amount} (-> £#{converted_amount}) on #{date}"
  total += converted_amount.to_f
  invoice.add_line_item(
    :quantity => 1,
    :unit_amount => converted_amount,
    :description => "#{date} - #{who}"
  )
end

invoice.save
puts "TOTAL: £%0.2f" % total
