# frozen_string_literal: true

def merge_sort(array)
  if array.length == 1
    array
  else
    midpoint = array.length / 2
    left = array[0, midpoint]
    right = array[midpoint..]
    merge(merge_sort(left), merge_sort(right))
  end
end

def merge(arr1, arr2) # rubocop:disable Metrics/MethodLength
  merged = []
  loop_count = arr1.length + arr2.length
  loop_count.times do
    if arr1.empty?
      merged += arr2
      break
    elsif arr2.empty?
      merged += arr1
      break
    end

    if arr1[0] > arr2[0]
      merged.push(arr2.delete_at(0))
    else
      merged.push(arr1.delete_at(0))
    end
  end
  merged
end
