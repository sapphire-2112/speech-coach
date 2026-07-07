from difflib import SequenceMatcher

VOWELS = {"a", "e", "i", "o", "u", "ai", "au", "oi", "ee", "oo", "aw", "er"}

SIMILAR = {
    "t": ["d", "th", "dh"],
    "d": ["t", "dh", "th"],
    "p": ["b", "f"],
    "b": ["p", "v", "m"],
    "k": ["g", "ch"],
    "g": ["k", "j"],
    "f": ["v", "p", "th"],
    "v": ["f", "w", "b"],
    "w": ["v", "u", "o"],
    "s": ["z", "sh", "th"],
    "z": ["s", "j", "dh"],
    "sh": ["s", "ch"],
    "ch": ["j", "sh", "t"],
    "j": ["ch", "z", "g"],
    "th": ["t", "f", "s", "dh"],
    "dh": ["d", "z", "th"],
    "r": ["l", "d"],
    "l": ["r", "n"],
    "n": ["ng", "m"],
    "ng": ["n", "m", "g"],
    "m": ["n", "ng", "b"],
    "a": ["e", "o", "u", "ai", "au"],
    "e": ["a", "i", "ai"],
    "i": ["e", "ee", "y"],
    "o": ["a", "u", "au"],
    "u": ["o", "oo", "w"],
    "ai": ["a", "e", "i"],
    "au": ["a", "o", "u", "aw"],
    "ee": ["i", "e"],
    "oo": ["u", "o"],
    "er": ["r", "a"],
}

ACCENT_ACCEPTED = {
    ("v", "w"),
    ("w", "v"),
    ("th", "t"),
    ("dh", "d"),
}


def compare(expected, spoken, accent="indian"):
    results = []
    matcher = SequenceMatcher(None, expected, spoken)

    for tag, i1, i2, j1, j2 in matcher.get_opcodes():
        if tag == "equal":
            for offset in range(i2 - i1):
                exp = expected[i1 + offset]
                spk = spoken[j1 + offset]
                results.append(_item("correct", exp, spk))
        elif tag == "replace":
            max_len = max(i2 - i1, j2 - j1)
            for offset in range(max_len):
                exp = expected[i1 + offset] if i1 + offset < i2 else None
                spk = spoken[j1 + offset] if j1 + offset < j2 else None
                results.append(_classify(exp, spk, accent))
        elif tag == "delete":
            for index in range(i1, i2):
                results.append(_item("missing", expected[index], None))
        elif tag == "insert":
            for index in range(j1, j2):
                results.append(_item("extra", None, spoken[index]))

    return results


def _classify(expected, spoken, accent):
    if expected and spoken and expected == spoken:
        return _item("correct", expected, spoken)

    if expected and spoken and _is_accent_match(expected, spoken, accent):
        return _item("accent_match", expected, spoken)

    if expected and spoken and _is_similar(expected, spoken):
        return _item("close", expected, spoken)

    if expected and spoken:
        return _item("wrong", expected, spoken)

    if expected:
        return _item("missing", expected, None)

    return _item("extra", None, spoken)


def _item(kind, expected, spoken):
    sound = expected or spoken or ""
    return {
        "type": kind,
        "expected": expected,
        "spoken": spoken,
        "sound_group": "vowel" if sound in VOWELS else "consonant",
        "tip": _tip(kind, expected, spoken),
    }


def _is_similar(left, right):
    return right in SIMILAR.get(left, []) or left in SIMILAR.get(right, [])


def _is_accent_match(expected, spoken, accent):
    if accent not in {"indian", "auto"}:
        return False
    return (expected, spoken) in ACCENT_ACCEPTED or (spoken, expected) in ACCENT_ACCEPTED


def _tip(kind, expected, spoken):
    if kind == "correct":
        return "Clear sound."
    if kind == "accent_match":
        return "Accepted Indian English pattern. Keep it clear and consistent."
    if kind == "close":
        return f"Close sound. Expected '{expected}', heard '{spoken}'. Exaggerate the target sound once, then speak naturally."
    if kind == "missing":
        return f"Missing '{expected}'. Slow down and finish the sound before moving ahead."
    if kind == "extra":
        return f"Extra '{spoken}' detected. Keep the word tighter and avoid adding filler sounds."
    return f"Expected '{expected}', heard '{spoken}'. Practice this pair slowly three times."
