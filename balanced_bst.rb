# frozen_string_literal: true

require('./merge_sort.rb')

# Nodes of the Tree
class Node
  include Comparable
  attr_accessor :value, :left, :right

  def initialize(value)
    @value = value
    @left = nil
    @right = nil
  end

  def <=>(other)
    value <=> other.value
  end
end

# The Balanced Binary Search Tree
class Tree
  attr_reader :root

  def initialize(array)
    @root = build_tree(array)
  end

  def build_tree(array)
    array = merge_sort(array).uniq
    breed_the_nodes(array)
  end

  def breed_the_nodes(array)
    last = array.length - 1
    mid = (0 + last) / 2

    return nil if 0 > last

    root = Node.new(array[mid])
    root.left = breed_the_nodes(array[0, mid])
    root.right = breed_the_nodes(array[mid + 1..last])

    root
  end

  def pretty_print(node = @root, prefix = '', is_left: true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", is_left: false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", is_left: true) if node.left
  end
end

Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]).pretty_print
