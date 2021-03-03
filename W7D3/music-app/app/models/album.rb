# == Schema Information
#
# Table name: albums
#
#  id         :bigint           not null, primary key
#  band_id    :integer          not null
#  title      :string           not null
#  year       :integer          not null
#  is_live    :boolean          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Album < ApplicationRecord
  validates :band_id, :title, :year, :is_live, {null: false}

  belongs_to :band
end
