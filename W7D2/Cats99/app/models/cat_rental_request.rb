# == Schema Information
#
# Table name: cat_rental_requests
#
#  id         :bigint           not null, primary key
#  name       :integer          not null
#  cat_id     :integer          not null
#  start_date :date             not null
#  end_date   :date             not null
#  status     :string           default("PENDING"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class CatRentalRequest < ApplicationRecord
  validates :status, {inclusion: ['PENDING', 'APPROVED', 'DENIED']}
  validates :cat_id, :start_date, :end_date, {presence: true}
  validate :does_not_overlap_approved_request
  validate :end_date_after_start_date

  belongs_to :cat

  private
  def end_date_after_start_date
    if start_date >= end_date
      errors[:base] << "The end date shall not precede or equal to the start date."
    end
  end

  def overlapping_approved_requests
    CatRentalRequest
      .where(cat_id: cat_id, status: 'APPROVED')
      .where.not("start_date > ? || end_date < ?", end_date, start_date)
  end

  def does_not_overlap_approved_request
    unless overlapping_approved_requests.empty?
      errors[:base] << "The current request is conflicting with an approved request."
    end
  end
end
