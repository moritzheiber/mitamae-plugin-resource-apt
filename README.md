# MItamae::Plugin::Resource::Apt

This mitamae plugin is supposed to handle:

- Installing regular Debian/Ubuntu packages using `apt`
- Install Debian/Ubuntu packages from remote locations
- Installing locally downloaded/sourced packages (not implemented)

## Usage

```ruby
apt 'package' do
  action [:install]
end
```

Available actions are `install` and `remove`.

### Installing a remote Debian package

```ruby
apt 'remote_package' do
  action [:install]
  source_url 'https://www.some.url/package.deb'
end
```

_Note: As of right now there's no integrity check. I'll add this at a later point in time._
