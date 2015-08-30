class User < ActiveRecord::Base

  has_many :messages

  validates_uniqueness_of :gcm_id
  validates_presence_of :email

end
