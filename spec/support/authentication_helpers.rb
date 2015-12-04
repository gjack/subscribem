module AuthenticationHelpers
  include Warden::Test::Helpers
  
  def sign_in_as(options = {})
    options.each do |scope, object|
      login_as(object, scope: scope)
    end
  end
end