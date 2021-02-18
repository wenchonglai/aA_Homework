class House < ApplicationRecord
  has_many(
    :persons,
    class_name: :Person,
    primary_key: :id,
    foreign_key: :house_id
  )
end