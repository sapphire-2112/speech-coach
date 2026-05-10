import nltk
from nltk.corpus import cmudict

# Automatically download cmudict if not present on the deployment server
try:
    nltk.data.find('corpora/cmudict')
except LookupError:
    nltk.download('cmudict')

d = cmudict.dict()

import re

def get_phonemes(phrase: str):
    phrase = phrase.lower()
    # Strip punctuation and keep only letters and spaces
    clean_phrase = re.sub(r'[^a-z\s]', '', phrase)
    words = clean_phrase.split()
    
    all_phonemes = []
    for word in words:
        if word in d:
            # Add the first pronunciation variant of the word
            all_phonemes.extend(d[word][0])
            
    return all_phonemes