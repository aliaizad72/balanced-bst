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

  def count_children
    if left.nil? && right.nil?
      0
    elsif left && right
      2
    else
      1
    end
  end

  def children_of?(parent_node)
    parent_node.left == left || parent_node.right == right
  end

  def left_of?(parent_node)
    return false unless children_of?(parent_node)

    case parent_node.count_children
    when 1
      !parent_node.left.nil?
    when 2
      parent_node.left == self
    end
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

    return nil if 0 > last # rubocop:disable Style/NumericPredicate

    root = Node.new(array[mid])
    root.left = breed_the_nodes(array[0, mid])
    root.right = breed_the_nodes(array[mid + 1..last])

    root
  end

  def insert(new_node, node = @root)
    if new_node < node.value
      if node.left.nil?
        node.left = Node.new(new_node)
        return
      end
      insert(new_node, node.left)
    elsif new_node > node.value
      if node.right.nil?
        node.right = Node.new(new_node)
        return
      end
      insert(new_node, node.right)
    elsif new_node == node.value
      'Value already exist in Tree!'
    end
  end

  def find(value, node = @root, parent_node = nil)
    if value == node.value
      [node, parent_node] # returns the node & porent
    elsif value > node.value
      find(value, node.right, node)
    elsif value < node.value
      find(value, node.left, node)
    end
  end

  def find_node(value)
    find(value)[0]
  end

  def find_parent_of(value)
    find(value)[1]
  end

  def delete(node)
    to_delete = find_node(node)
    parent_of_to_delete = find_parent_of(node)

    case to_delete.count_children
    when 0
      if to_delete.left_of?(parent_of_to_delete)
        parent_of_to_delete.left = nil
      else
        parent_of_to_delete.right = nil
      end
    when 1
    else 2
    end
  end

  def pretty_print(node = @root, prefix = '', is_left: true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", is_left: false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", is_left: true) if node.left
  end
end

tree = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])
tree.pretty_print
tree.delete(3)
tree.pretty_print
