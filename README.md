# zonesync

Sync your DNS host with your DNS zone file, making it easy to version your zone file and sync changes.

## Why?

Configuration management is important, and switched-on technical types now agree that "configuration is code". This means that your DNS configuration should be treated with the same degree of respect you would give to any other code you would write.

In order to live up to this standard, there needs to be an easy way to manage your DNS host file in a SCM tool like Git, allowing you to feed it into a continuous integration pipeline. This library enables this very ideal, making DNS management no different to source code management.

## How?

### Install

Add `zonesync` to your Gemfile:

```ruby
source 'https://rubygems.org'

gem 'zonesync'
```

or run:

`gem install zonesync`

### DNS zone file

The following is an example DNS zone file for `example.com`:

```
$ORIGIN example.com.
$TTL 1h
example.com.  IN  SOA  ns.example.com. username.example.com. (2007120710; 1d; 2h; 4w; 1h)
example.com.  NS    ns
example.com.  NS    ns.somewhere.example.
example.com.  MX    10 mail.example.com.
@             MX    20 mail2.example.com.
@             MX    50 mail3
example.com.  A     192.0.2.1
              AAAA  2001:db8:10::1
ns            A     192.0.2.2
              AAAA  2001:db8:10::2
www           CNAME example.com.
wwwtest       CNAME www
mail          A     192.0.2.3
mail2         A     192.0.2.4
mail3         A     192.0.2.5
```

### DNS Host

We need to tell `zonesync` about our DNS host by building a small YAML file. The structure of this file will depend on your DNS host, so here are some examples:

**DNSimple**

```
provider: DNSimple
dnsimple_email: <DNSIMPLE_EMAIL>
dnsimple_password: <DNSIMPLE_PASSWORD>
```

**Route 53**

```
provider: AWS
aws_access_key_id: <AWS_ACCESS_KEY_ID>
aws_secret_access_key: <AWS_SECRET_ACCESS_KEY>
```

> Note: `zonesync` uses `fog` to support a range of DNS hosts. See [fog's DNS documentation](http://fog.io/dns/) or [the `Fog::DNS` source code](https://github.com/fog/fog/blob/master/lib/fog/dns.rb) for help with other DNS hosts.

### Usage

Assuming your zone file lives in `hostfile.txt` and your DNS provider credentials are configured in `provider.yml`, there are two ways to invoke `zonesync`:

#### CLI

```
$ zonesync -z hostfile.txt -p provider.yml

Synced <n> records for <domain> to <provider>
```

#### Rake task

Add the following lines to your `Rakefile`:

```ruby
require 'zonesync/rake_task'

ZoneSync::RakeTask.new(zonefile: 'hostfile.txt', credentials: 'provider.yml')
```

You can then run `rake zonesync`.
