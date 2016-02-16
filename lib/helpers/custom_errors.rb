module CustomErrors
  class AuthenticationError < StandardError
    def initialize(msg="You need to call #authenticate first and pass in your email and password. For example: Teachable::Stats.authenticate(email: 'YourEmail@example.com', password: 'password')")
      super
    end
  end

  class RegistrationError < StandardError
    def initialize(msg="That username and password combination is incorrect. I think you need to register first.")
      super
    end
  end
end
