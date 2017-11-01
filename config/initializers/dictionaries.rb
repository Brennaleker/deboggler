# intialize language dictionaries here for consumption by trie

# initializing English dictionary array and removing unscorable words
ENGLISH = File.read('.//public/dictionaries/english.txt')
  .split("\n")
  .reject {|word| word.size < 3}
