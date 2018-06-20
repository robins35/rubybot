# On Linux (Debian/Ubuntu)

sudo apt-get install postgresql libpq-dev

# Create DB user and grant privileges
`sudo -u postgres createuser <username>`

`$ sudo -u postgres psql
psql=# alter user <username> with encrypted password '<password>';`

`psql=# grant all privileges on database <dbname> to <username> ;`

`ALTER USER <username> CREATEDB;`

`rake db:create`

`rake db:migrate`

# Run the bot

`ruby bot.rb`
