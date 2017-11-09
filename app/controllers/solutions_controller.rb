class SolutionsController < ApplicationController
  require 'trie'
  respond_to :json

# TODO write unit and integ tests
  def index

  end

  def solve()
    @board_width = 4
    @board = create_board(JSON.parse(params[:board_input]))
    results = find_all_words()

    respond_with json: results
  end

  def generate_dictionary(dictionary)
    trie = Trie.new
    dictionary.each { |word| trie.add word }
    return trie
  end

  def find_all_words()
    dictionary_trie = generate_dictionary(ENGLISH)
    results = Set.new
    @board.each do |square|
      find_paths(square, dictionary_trie.root, results)
    end

    # TODO add in total_points_possible ex:72
    results_sorted = {
      one_point: {
        three_letters: results.to_a.select {|x| x.length == 3}.sort,
        four_letters: results.to_a.select {|x| x.length == 4}.sort
      },
      two_point: results.to_a.select {|x| x.length == 5}.sort,
      three_point: results.to_a.select {|x| x.length == 6}.sort,
      five_point: results.to_a.select {|x| x.length == 7}.sort,
      # six point answers come in multiple lengths, sorting by length then alphabetically
      six_point: results.to_a.select {|x| x.length > 7}.sort { |a, b| [a.size, a] <=> [b.size, b] }
    }
  end

  def find_paths(square, dictionary_node, results, prefix = "", visited = [] )
    current_prefix = prefix + square[:letter]
    current_node = dictionary_node
    # walk down the branch
    current_node = current_node.walk(square[:letter])

    # exit if we are out of legal path moves
    return unless current_node
    # if node is at end of a branch of the dictionary add to results
    if current_node.terminal?
      results << current_prefix
    end
    # exit if there are no branches at this node
    return if current_node.leaf?

    #iterate through all of the unvisited neighbor paths
    open_paths = square[:neighbors] - visited
    open_paths.each do |path|
      neighbor_square = @board.select {|square| square[:location] == path}.first
      find_paths(neighbor_square, current_node, results, current_prefix, visited + [square[:location]])
    end
  end

  def find_neighbors(square)
    # the eight possible neighbor directions from square
    neighbor_distances = [[1,0],[-1,0],[0, 1],[0, -1],[-1, -1], [1, -1], [1, 1], [-1, 1]]
    neighbor_distances.each do |dx, dy|
      nx = square[:location][0] + dx
      ny = square[:location][1] + dy
      if nx.between?(0, (@board_width - 1)) && ny.between?(0, (@board_width - 1))
        square[:neighbors].push([nx, ny])
      end
    end
  end

  def create_board(board_input)
    board = []
    x = 0
    board_input.each do |row|
      y = 0
      row.each do |column|
        letter = {
          letter: board_input[x][y].downcase,
          location: [x, y],
          neighbors: []
        }
        board.push(letter)
        y += 1
      end
      x += 1
    end
    board.each do |square|
      find_neighbors(square)
    end

    return board
  end
end
