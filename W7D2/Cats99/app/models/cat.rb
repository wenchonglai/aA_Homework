# == Schema Information
#
# Table name: cats
#
#  id          :bigint           not null, primary key
#  birth_date  :date             not null
#  color       :string           not null
#  name        :string           not null
#  sex         :string(1)        not null
#  url         :string           not null
#  description :text             default("")
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require "action_view"

class Cat < ApplicationRecord
  include ActionView::Helpers::DateHelper

  COLORS = ['brown', 'orange', 'white', 'black', 'golden', 'blue', 'grey']

  validates :birth_date, :name, { presence: true }
  validates :color, { inclusion: COLORS }
  validates :sex, { inclusion: ['M', 'F'] }

  has_many :cat_rental_requests, {dependent: :destroy}
  belongs_to :owner,
    foreign_key: :user_id,
    class_name: :User

  validates :owner, {presence: true}
  # validate age

  def new
    super
  end

  def age
    time_ago_in_words(self.birth_date)
  end
end
