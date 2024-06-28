class User < ApplicationRecord
    has_secure_password

    validates_uniqueness_of :email
    validates_presence_of :email
    validates_presence_of :password, on: :create

    #on ajoute ces relations car si le compte est détruit il ne peut être acheteur ou vendeur
    has_many :buyers, dependent: :destroy
    has_many :sellers, dependent: :destroy
end
