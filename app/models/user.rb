# frozen_string_literal: true

class User < ActiveRecord::Base
  include LikeSearchable
  include Paginatable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  include DeviseTokenAuth::Concerns::User

  has_one :address, dependent: :destroy
  has_many :consults, dependent: :destroy
  has_many :room_rents, dependent: :destroy
  has_many :books, dependent: :destroy

  validates :name, presence: true
  validates :profile, presence: true
  validates :phone, presence: true
  validates :whatsapp_avaliable, inclusion: { in: [ true, false ] }
  enum profile: { admin: 0, paciente: 1, especialista: 2 }

end
