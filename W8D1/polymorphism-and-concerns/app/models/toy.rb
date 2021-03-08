class Toy < ApplicationRecord
  belongs_to :toyable, dependent: :destroy, polymorphic: true
  validates :name, null: false
  validates :name, uniqueness: {scope: :toyable}
end
