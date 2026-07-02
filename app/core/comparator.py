from difflib import SequenceMatcher

SIMILAR = {
    # Vowels (Indian accents often merge these)
    "e": ["a", "i", "ai"],
    "a": ["e", "o", "u", "au"],
    "i": ["e", "iy"],
    "o": ["a", "u", "au", "ou"],
    "u": ["o", "oo", "uh"],
    
    # Consonants (Indian English variations)
    "v": ["w", "bh"],
    "w": ["v"],
    "th": ["t", "d", "dh"], # 'th' in think/that -> t/d
    "dh": ["d", "th"],
    "t": ["th", "d"],
    "d": ["dh", "th"],
    "sh": ["s"],
    "s": ["sh", "z"],
    "z": ["s", "j"],
    "j": ["z"],
    "n": ["ng"],
    "ng": ["n"],
    "r": ["l", "d"], # Retroflex R
    "l": ["r"],
    "ph": ["f", "p"],
    "f": ["ph", "p"]
}

def compare(expected, spoken):
    results = []
    
    # Use SequenceMatcher to align the phoneme arrays intelligently
    sm = SequenceMatcher(None, expected, spoken)
    
    for tag, i1, i2, j1, j2 in sm.get_opcodes():
        if tag == 'equal':
            for _ in range(i1, i2):
                results.append({"type": "correct"})
        elif tag == 'replace':
            # Check if the replacement is an acceptable Indian variation
            exp_sub = expected[i1:i2]
            spk_sub = spoken[j1:j2]
            
            for e, s in zip(exp_sub, spk_sub):
                if e in SIMILAR and s in SIMILAR[e]:
                    results.append({"type": "acceptable", "expected": e, "spoken": s})
                else:
                    results.append({"type": "wrong", "expected": e, "spoken": s})
            
            # Handle unequal lengths (e.g., deleted or inserted during replace)
            if len(exp_sub) > len(spk_sub):
                for _ in range(len(exp_sub) - len(spk_sub)):
                    results.append({"type": "missing"})
            elif len(spk_sub) > len(exp_sub):
                for _ in range(len(spk_sub) - len(exp_sub)):
                    results.append({"type": "extra"})
        elif tag == 'delete':
            for _ in range(i1, i2):
                results.append({"type": "missing"})
        elif tag == 'insert':
            for _ in range(j1, j2):
                results.append({"type": "extra"})

    return results