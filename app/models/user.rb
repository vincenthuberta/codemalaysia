class User < ActiveRecord::Base
    has_many :microposts, dependent: :destroy #if user is destroyed, its microposts are too.
    attr_accessor   :remember_token, :activation_token, :reset_token
    before_save     :downcase_email
    before_create   :create_activation_digest
    
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
    def authenticated?(attribute, token)
        digest = send("#{attribute}_digest")
        return false if digest.nil?
        BCrypt::Password.new(digest).is_password?(token)
    end
    
    #forgets a user
    def forget 
        update_attribute(:remember_digest, nil) #by updating remember_digest with nil, there will be no user data.
                                                #thus logged out.
    end
    
    def activate
        #update_attribute(:activated, true)
        #update_attribute(:activated_at, Time.zone.now)
        update_columns(activated: true, activated_at: Time.zone.now)
    end
    
    def send_activation_email
        UserMailer.account_activation(self).deliver_now
    end
    
    def create_reset_digest
        self.reset_token = User.new_token
        #update_attribute(:reset_digest, User.digest(reset_token))
        #update_attribute(:reset_sent_at, Time.zone.now)
        update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
    end
    
    def send_password_reset_email
        UserMailer.password_reset(self).deliver_now
    end
    
    #returns true if a password reset has expired
    def password_reset_expired?
        reset_sent_at < 2.hours.ago
    end
    
    #Defines a proto-feed
    #See "Following users" for the full implementation
    def feed
        Micropost.where("user_id = ?", id)
    end

    private
    
    #converts email to all lower-case
    def downcase_email
        self.email = email.downcase
    end
    
    #creates and assigns the activation token and digest
    def create_activation_digest
        self.activation_token = User.new_token
        self.activation_digest = User.digest(activation_token)
    end
end
