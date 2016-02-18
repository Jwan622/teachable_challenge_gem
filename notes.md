## Some design choices

I think the design of this gem was heavily influenced by these links:
[configuration module](https://viget.com/extend/easy-gem-configuration-variables-with-defaults)

I include the Configuration model for the times when the user's configuration changes at runtime.

I wrote the method signatures with keyword arguments because I'm all about that life (it sincerity, it does 3 things for us:
  1. allows us to see what the names of the arguments are without having to read the method of the body.
  2. reduces boiletplate code for extracting hash options.
  3. The calling method is syntactically equal to calling a method with hash options.)

-the email parameter in create_order is probably redundant or at least unclear. Do we want the behavior to be that only a user can create orders only for himself or for other users? I assume we only want users to create their own orders. IF that's the case, then I think the email parameter is redundant and perhaps behavior we don't want.
- the number column when create a new order is a random string of letters. I took the liberty in interpreting number as just the number of orders to create with the specific parameters of total, total_quantity, and the associated email. For example:

This curl request:
```
curl -X POST -d '{ "order": { "total": "2", "total_quantity": "1", "email": "valid_email1@example.com", "special_instructions": "special instructions foo bar" } }' 'https://fast-bayou-75985.herokuapp.com/api/orders.json?user_email=valid_email1@example.com&user_token=-y9s9TyMHdWmniBLfE8i' -i -H "Accept: application/json" -H "Content-Type: application/json"
```

results in:

```
{"id":65,"number":"699dc850250c6ded","total":"2.0","total_quantity":1,"email":"valid_email1@example.com","special_instructions":"special instructions foo bar","created_at":"2016-02-15T19:09:04.478Z","updated_at":"2016-02-15T19:09:04.478Z"}
```

and that number is an odd field. What is that supposed to be anyway?

I have some helper methods in my spec_helper... where should they go?
I was thinking of putting them in spec/helpers... but I actually put a test that tests my helper methods in there. So where should helper methods for my specs actually go? I feel like I misused some folders...


### teardown
.delete_all_orders_of_current_user is in the spec_helper and it cleares all the orders associated with the current user.

Ideally I'd also like to delete the users I created in my tests that register new users, but I currently cannot.
