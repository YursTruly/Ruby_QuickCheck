require 'ronin/database'
require 'ronin/user_name'
require 'ronin/host_name'
require 'ronin/email_address'

Ronin::Database.setup
p "DB setup successful"
email = Ronin::EmailAddress.parse('alice@example.com')
p "Email Parsed"
email.user_name
email.host_name.name
p "Names retrieved"
email.save #error
p "Email saved"
Ronin::EmailAddress.first.host_name