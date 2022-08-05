require 'jwt'
class Author < ApplicationRecord
    SECRET_KEY = Rails.application.secrets.secret_key_base.to_s
    validates :first_name, :last_name, :email, :password, presence: true
    validates :password, 
      length: {  minimum: 8 }, 
      on: :create,
      format: { 
        with: /\A(?=.*[A-Z])(?=.*[0-9]).*\z/,
        message: "Must be 8 or more characters, have an uppercase letter, and a number." 
      },
      confirmation: true
    validates_confirmation_of :password
    validates :email, 
      uniqueness: true, 
      format: { 
        with: /\A(.+)@(.+)\z/, 
        message: "Email must have '@' symbol and a domain." 
    }

    def self.set_auth_token(payload)
      JWT.encode(payload, SECRET_KEY)
    end
  
    def self.get_auth_token(token)
      JWT.decode(token, SECRET_KEY)
    end
end
