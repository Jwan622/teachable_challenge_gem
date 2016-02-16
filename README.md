# Teachable Stats Gem

Easy to use and configure gem wrapper for the Teachable API.

#### Why does the Teachable-Stats gem exist?

The Teachable::Stats wrapper gem exists to make hitting the Teachable API much easier. No longer do you need to struggle through rest-client or Faraday and constantly send over your user_email and user_token. Now you can just authenticate once with your email and password and hit all the endpoints conveniently!

#### Installation

Add this line to your application's Gemfile:

```ruby
gem 'teachable-stats'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install teachable-stats

## Usage

**Registering to the API**
In order to use the gem, you first need to register an account with Teachable. You used to have to make a complicated post request directly to Teachable's API via this complicated curl request:

```bash
curl -X POST -d '{ "user": { "email": "valid_email1@example.com", "password": "password" }}' https://fast-bayou-75985.herokuapp.com//users/sign_in.json -i -H "Accept: application/json" -H "Content-Type: application/json"
```

But no longer! After you've included this gem in your Gemfile and run 'bundle', you can register to the Teachable using this much simpler method call:

```ruby
Teachable::Stats.register(email: "new_email@example.com", password: "8LettersLongAtLeast", password_confirmation: "8LettersLongAtLeast")
```

Note the password field has to be at least 8 letters long and the email address cannot already exist in the database.

**Getting user_token and credentials**
If you are an already registered user and simply want your credentials sent back to you, you can simply get your credentials via this .get_token convenience method

```ruby
Teachable::Stats.get_token(email: "registered_email@example.com", password: "validPassword")
```

That will return your credentials, including your token, in this form:

```
{"id"=>36,
 "name"=>nil,
 "nickname"=>nil,
 "image"=>nil,
 "email"=>"registered_email@example.com",
 "tokens"=>"-y9s9TyMHdWmniBLfE8i",
 "created_at"=>"2016-02-14T20:53:19.896Z",
 "updated_at"=>"2016-02-16T00:00:08.120Z"}
```

Note the returned value of the .get_token method is a ruby hash and it does not show your password. However, it does have your user_token which you need to use to configure your gem.

**Configuring your gem**
You need to set your :user_email and :user_token prior to making API requests to the Teachable API. Configuring your gem simply means providing the gem your registered user email and user_token. There are two ways to do this:

1. In your application, you can write this code to manually configure your gem:

```ruby
Teachable::Stats.configuration do |config|
  config.user_email = "your_email@example.com"
  config.user_token = "some_secure_random_string_goes_here_that_you_can_get_via_the_get_token_method"
end
```

Again, the user_email and user_token can be obtained via the .get_token method provided by the gem.

2. You can also configure your gem using the gem's .authenticate convenience method. This is how you can use the convenience method.

```ruby
Teachable::Stats.authenticate(email: "valid_email1@example.com", password: "password")
```

Give that above method a try! That email and password are valid. You should see something like this return:

```
"Logged in as user: valid_email1@example.com with token: -y9s9TyMHdWmniBLfE8i"
```

Behind the scenes, that sets the class variables called user_email and user_token to the email and user_token that are shown in the string. All you need to provide to the authenticate convenience method are your already registered and valid email and password. That's it!

## Making queries to the Teachable API

Once you've registered and authenticated, you an start making queries to the API. Currently, the Teachable API has 4 endpoints:

1. Users#get
2. Orders#get
3. Orders#post
4. Orders#destroy

Let's see how to make requests to all 4!

**Users#get**
```ruby
Teachable::Stats.get_user
```

**Orders*get**
```ruby
Teachable::Stats.get_orders
```

**Orders*post**
```ruby
Teachable::Stats.create_my_order(number: 1, total: 2.0, total_quantity: 3, email: "valid_email1@example.com")
```

In the above convenience method for creating_orders, you currently need to provide your registered email. However, in future versions we will likely take this away since your are currently authenticated by this point.

The above method will create an order for the authenticated user. See this:

```ruby
Teachable::Stats.destroy_my_order(order_id: 2)
```

The above convenience method will destroy an order for the currently authenticated user. The order destroyed order will be the one that has an :id equal to the order_id provided to the method.


#### Examples

```ruby
Teachable::Stats.register(email: "newly_registered_email@example.com", password: "new_password", password_confirmation: "new_password")
```

```
=> {"id"=>41,
 "name"=>nil,
 "nickname"=>nil,
 "image"=>nil,
 "email"=>"newly_registered_email@example.com",
 "tokens"=>"jXVrTVgt9UQmLYGe2f8P",
 "created_at"=>"2016-02-16T06:00:46.784Z",
 "updated_at"=>"2016-02-16T06:00:46.806Z"}
```

```ruby
Teachable::Stats.get_token(email: "newly_registered_email@example.com", password: "new_password")
```

```
=> {"id"=>41,
 "name"=>nil,
 "nickname"=>nil,
 "image"=>nil,
 "email"=>"newly_registered_email@example.com",
 "tokens"=>"jXVrTVgt9UQmLYGe2f8P",
 "created_at"=>"2016-02-16T06:00:46.784Z",
 "updated_at"=>"2016-02-16T06:02:09.474Z"}
```

At this point, the .user_email and .user_token getters are still unset
```
Teachable::Stats.user_email
=> nil

Teachable::Stats.user_token
=> nil
```

Let's set the user_token and user_email via the authenticate convenience method.

```ruby
Teachable::Stats.authenticate(email: "newly_registered_email@example.com", password: "new_password")
```

```
=> "Logged in as user: newly_registered_email@example.com with token: jXVrTVgt9UQmLYGe2f8P"
```

We can see that the getter convenience methods are now set.

```ruby
Teachable::Stats.user_email
=> "newly_registered_email@example.com"
[8] pry(main)> Teachable::Stats.user_token
=> "jXVrTVgt9UQmLYGe2f8P"
```

Now we can freely access the API:

Let's get the orders for the current authenticated user. There should be none:

```ruby
Teachable::Stats.get_orders
```

```
=> []
```

Let's try to get the current authenticated user.

```ruby
Teachable::Stats.get_user
```

```
Teachable::Stats.get_user
=> {"id"=>41,
 "name"=>nil,
 "nickname"=>nil,
 "image"=>nil,
 "email"=>"newly_registered_email@example.com",
 "tokens"=>"jXVrTVgt9UQmLYGe2f8P",
 "created_at"=>"2016-02-16T06:00:46.784Z",
 "updated_at"=>"2016-02-16T06:05:01.396Z"}
```

Let's create an order:

```ruby
Teachable::Stats.create_my_order(number:1, total:2, total_quantity:3, email:"newly_registered_email@example.com")
```

```
=> [{"id"=>140,
  "number"=>"e333b0d103f5ce52",
  "total"=>"2.0",
  "total_quantity"=>3,
  "email"=>"newly_registered_email@example.com",
  "special_instructions"=>"special instructions foo bar",
  "created_at"=>"2016-02-16T06:06:24.710Z",
  "updated_at"=>"2016-02-16T06:06:24.710Z"}]
```

Let's check to see if that order was created.

```ruby
Teachable::Stats.get_orders
```

```
=> [{"id"=>140,
  "number"=>"e333b0d103f5ce52",
  "total"=>"2.0",
  "total_quantity"=>3,
  "email"=>"newly_registered_email@example.com",
  "special_instructions"=>"special instructions foo bar",
  "created_at"=>"2016-02-16T06:06:24.710Z",
  "updated_at"=>"2016-02-16T06:06:24.710Z"}]
```

Let's destroy that order:

```ruby
Teachable::Stats.destroy_my_order(order_id:140)
```

```
=> "Order with id: 140 deleted."
```

We should no longer have any orders associated with this user:

```ruby
Teachable::Stats.get_orders
```

```
=> []
```

Mad easy right?

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/teachable-stats.

Many thanks to the development team:
- Jeffrey Wan
- Noah Pryor
- Dustin Eichler
- The kind folks at Teachable!
