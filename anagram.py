# Anagram, a word formed by rearranging letter from a different number. by using logic factorial

def generate_anagrams(word):
    if len(word) == 1:
        return [word]
    
    anagrams = []
    for i, char in enumerate(word):
        remaining = word[:i] + word[i+1:]
        for sub_anagram in generate_anagrams(remaining):
            anagrams.append(char + sub_anagram)
    
    return anagrams

def anagram(word):
    anagrams = generate_anagrams(word)
    print(anagrams)

# Example usage:
anagram(input("Enter string "))
   
