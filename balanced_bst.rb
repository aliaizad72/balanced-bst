# frozen_string_literal: true

require('./merge_sort.rb')

# Nodes of the Tree
class Node
  include Comparable
  attr_accessor :value, :left, :right

  def initialize(value)
    @value = value
    @left = null
    @right = null
  end

  def <=>(other)
    value <=> other.value
  end
end
