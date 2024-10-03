# anagram with multiple words

def lenth(words):
    for i in words:
        if len(i) <= 1:
            words.remove(i)
    return words, len(words)
    


print(lenth(["string", "trings", "s"]))


string = "example"

for i in string:
    char_to_find = i
    if char_to_find in string:
        print(f"The character '{char_to_find}' is in the string.")
    else:
        print(f"The character '{char_to_find}' is not in the string.")

