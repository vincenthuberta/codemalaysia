class User < ActiveRecord::Base
    
    attr_accessor :remember_token
    
    #remembers a user in the database for use in persistent sessions.
    def remember
        self.remember_token = User.new_token #generate a token / random string
        update_attribute(:remember_digest, User.digest(remember_token))
    end
    
    before_save {email.downcase!}
    validates(:name, presence: true, length: {maximum: 50})
  
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    validates(:email, presence: true, length: {maximum: 255}, 
            format: { with: VALID_EMAIL_REGEX }, 
            uniqueness: {case_sensitive: false})
    
    has_secure_password
    validates(:password, length: {minimum: 6}, allow_blank: true) #allow the password to be blank
    
    
    #returns the hash digest of the given string
    def self.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end
    
    #returns a random token or 22 characters random string
    def self.new_token
        SecureRandom.urlsafe_base64
    end
    
    #returns true if the given token matches the digest
    def authenticated?(remember_token)
        return false if remember_digest.nil?
        BCrypt::Password.new(remember_digest).is_password?(remember_token)
    end
    
    #forgets a user
    def forget 
        update_attribute(:remember_digest, nil) #by updating remember_digest with nil, there will be no user data.
                                                #thus logged out.
    end
end
