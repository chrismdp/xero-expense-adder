# encoding: utf-8
require 'xeroizer'
require 'yaml'

config = YAML.load(File.read("keys.yaml"))

client = Xeroizer::PrivateApplication.new(config['key'], config['secret'], "privatekey.pem")

me = client.Contact.find(config['contact'])

invoice = client.Invoice.build(:type => "ACCPAY")
invoice.contact = me

Dir[ARGV[0] + '/*.pdf'].each do |file|
  whole, date, who, amount = File.basename(file).match(/(.*?) (.*?) £(.*?)\.pdf/).to_a
  puts "Adding line item for #{who}: spent #{amount} on #{date}"
  invoice.add_line_item(
    :quantity => 1,
    :unit_amount => amount,
    :description => "#{date} - #{who}"
  )
end

invoice.save
