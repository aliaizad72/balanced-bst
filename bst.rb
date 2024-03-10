# frozen_string_literal: true

# Tree nodes which contains 3 properties
class Node
  attr_accessor :key, :parent, :left, :right

  def initialize(key)
    @key = key
    @parent = nil
    @left = nil
    @right = nil
  end
end

# The tree which consists of a root node
class Tree
  attr_reader :root

  def initialize(array)
    array = array.sort.uniq
    @root = build_tree(array)
  end

  def build_tree(array, parent_node = nil) # rubocop:disable Metrics/MethodLength
    first_i = 0
    last_i = array.length - 1
    mid = (first_i + last_i) / 2

    if first_i > last_i
      nil
    else
      node = Node.new(array[mid])
      node.parent = parent_node
      node.left = build_tree(array[first_i, mid], node)
      node.right = build_tree(array[mid + 1..last_i], node)
      node
    end
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.key}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def search(key, node = @root)
    if node.nil? || node.key == key
      node
    elsif key < node.key
      search(key, node.left)
    else
      search(key, node.right)
    end
  end

  def min(node = @root)
    if node.left.nil?
      node
    else
      min(node.left)
    end
  end

  def max(node = @root)
    if node.right.nil?
      node
    else
      max(node.right)
    end
  end

  def neighbor(node, successor: true)
    node = search(node)
    return 'No such node!' if node.nil?

    child = if successor
              node.right
            else
              node.left
            end

    unless child.nil? # rubocop:disable Style/UnlessElse
      if successor
        min(child)
      else
        max(child)
      end
    else
      parent = node.parent
      compare_direction = if successor
                            parent.right
                          else
                            parent.left
                          end

      while parent.nil? == false && node == compare_direction
        node = parent
        parent = parent.parent
      end
      parent
    end
  end

  def successor(node)
    neighbor(node, successor: true)
  end

  def predecessor(node)
    neighbor(node, successor: false)
  end

  def insert(key)
    node = Node.new(key)
    pointer = @root
    trailing_pointer = nil

    until pointer.nil?
      trailing_pointer = pointer
      if node.key < pointer.key
        pointer = pointer.left
      else
        pointer = pointer.right
      end
    end

    node.parent = trailing_pointer

    if trailing_pointer.nil?
      @root = node
    elsif node.key < trailing_pointer.key
      trailing_pointer.left = node
    else
      trailing_pointer.right = node
    end
  end

  def transplant(to_be_replaced, replacement)
    if to_be_replaced.parent.nil?
      @root = replacement
    elsif to_be_replaced == to_be_replaced.parent.left
      to_be_replaced.parent.left = replacement
    else
      to_be_replaced.parent.right = replacement
    end

    replacement.parent = to_be_replaced.parent unless replacement.nil?
  end

  def delete(node)
    node = search(node)

    if node.left.nil?
      transplant(node, node.right)
    elsif node.right.nil?
      transplant(node, node.left)
    else
      successor = min(node.right)

      unless successor == node.right
        transplant(successor, successor.right)
        successor.right = node.right
        successor.right.parent = successor
      end
      transplant(node, successor)
      successor.left = node.left
      successor.left.parent = successor
    end
  end

  def level_order
    queue = []
    queue.push(@root)

    until queue.empty?
      current_node = queue[0]
      queue.push(current_node.left) unless current_node.left.nil?
      queue.push(current_node.right) unless current_node.right.nil?
      yield queue.shift.key
    end
  end

  def recursive_level_order(queue = [@root], &block)
    return if queue.empty?

    current_node = queue[0]
    queue.push(current_node.left) unless current_node.left.nil?
    queue.push(current_node.right) unless current_node.right.nil?
    block.call(queue.shift.key)
    recursive_level_order(queue, &block)
  end

  def inorder(node = @root, &block)
    return if node.nil?

    inorder(node.left, &block)
    block.call(node.key)
    inorder(node.right, &block)
  end

  def preorder(node = @root, &block)
    return if node.nil?

    block.call(node.key)
    preorder(node.left, &block)
    preorder(node.right, &block)
  end

  def postorder(node = @root, &block)
    return if node.nil?

    postorder(node.left, &block)
    postorder(node.right, &block)
    block.call(node.key)
  end

  def height(node = @root)
    node = search(node) if node.is_a? Integer

    return 0 if node.nil?

    return 1 if node.right.nil? && node.left.nil?

    [height(node.left), height(node.right)].max + 1
  end

  def depth(node = @root)
    node = search(node) if node.is_a? Integer
    return 0 if node.parent.nil?

    pointer = node.parent
    d = 0

    until pointer.nil?
      pointer = pointer.parent
      d += 1
    end
    d
  end
end

tree = Tree.new([56, 99, 12, 77, 42])
tree.pretty_print
p tree.depth(99)
