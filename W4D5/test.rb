require "byebug"

def find_max(arr, n)
  q_1 = [[arr[0], 0]]
  q_2 = []
  max_arr = [arr[0]]
  len = arr.length

  (1...len).each do |i|
    if arr[i] < q_1.last[0]
      q_2.unshift(q_1.pop) until q_1.empty? || q_1.last[0] < arr[i]
    end

    q_1 << [arr[i], i]

    if q_1.length + q_2.length > n
      f_1 = q_1.first
      f_2 = q_2.first

      if f_1.nil?
        q_2.shift
        max_arr << q_2.last[0]
      elsif f_2.nil?
        q_1.shift
        max_arr << q_1.last[0]
      else
        (f_1[1] < f_2[1] ? q_1 : q_2).shift
      end
    end

    max_arr << ( (q_2.empty? || q_1.last[0] > q_2.last[0] ) ? q_1 : q_2 ).last[0]
  end

  max_arr
end

p find_max([3,1,4,1,5,9,2,6,5,3,5,8], 3)