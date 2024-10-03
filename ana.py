import itertools

# Function to calculate factorial using recursion
def factorial_recursive(n):
    if n == 0 or n == 1:
        return 1
    else:
        return n * factorial_recursive(n - 1)

# Function to generate and print all anagrams of a word
def generate_anagrams(word):
    # Generate all permutations of the word
    anagrams = set(itertools.permutations(word))
    
    # Convert permutations from tuples to strings
    anagram_list = [''.join(permutation) for permutation in anagrams]
    
    # Print the anagrams
    print("All anagrams of the word '{}':".format(word))
    for anagram in anagram_list:
        print(anagram)

# Example usage
generate_anagrams("len")
